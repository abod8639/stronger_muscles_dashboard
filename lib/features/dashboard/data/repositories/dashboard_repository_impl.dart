import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/mappers/dashboard_mapper.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import 'package:stronger_muscles_dashboard/features/users/users_feature.dart';

/// Single Source of Truth for Dashboard Data.
/// Orchestrates calls between Remote data aggregation and Hive LocalDataSource caching.
/// Isolated computational heavy-lifting in background Isolate via [compute].
class DashboardRepositoryImpl implements DashboardRepository {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;
  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource? _remoteDataSource;

  DashboardRepositoryImpl({
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
    required UserRepository userRepository,
    required DashboardLocalDataSource localDataSource,
    DashboardRemoteDataSource? remoteDataSource,
  })  : _orderRepository = orderRepository,
        _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        _userRepository = userRepository,
        _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats({
    bool forceRefresh = false,
  }) async {
    // 1. Check local Hive cache if refresh is not forced
    if (!forceRefresh) {
      final isCacheValid = await _localDataSource.isCacheValid();
      if (isCacheValid) {
        try {
          final cachedModel = await _localDataSource.getCachedStats();
          if (cachedModel != null) {
            return Right(cachedModel.toEntity());
          }
        } catch (_) {
          // If cache read fails, proceed to live aggregation
        }
      }
    }

    // 2. Fetch fresh domain data (try direct remote stats if available, fallback to constituent aggregation)
    try {
      if (_remoteDataSource != null) {
        try {
          final remoteModel = await _remoteDataSource.getRemoteStats();
          final entity = remoteModel.toEntity();
          await _localDataSource.cacheStats(remoteModel);
          return Right(entity);
        } catch (_) {
          // If direct endpoint is unavailable or fails, fallback to constituent services
        }
      }

      final ordersResult = await _orderRepository.getOrders();
      final productsResult = await _productRepository.getProducts();
      final categoriesResult = await _categoryRepository.getCategories();
      final usersResult = await _userRepository.getUsersStats();

      if (ordersResult.isLeft() &&
          productsResult.isLeft() &&
          categoriesResult.isLeft() &&
          usersResult.isLeft()) {
        throw const ServerException(message: 'Constituent dashboard services failed');
      }

      final orders = ordersResult.fold(
        (failure) {
          debugPrint('Dashboard: Orders fetch returned failure: ${failure.message}');
          return <OrderEntity>[];
        },
        (ords) => ords,
      );

      final products = productsResult.fold(
        (failure) {
          debugPrint('Dashboard: Products fetch returned failure: ${failure.message}');
          return <ProductEntity>[];
        },
        (prods) => prods,
      );

      final categories = categoriesResult.fold(
        (failure) {
          debugPrint('Dashboard: Categories fetch returned failure: ${failure.message}');
          return <CategoryEntity>[];
        },
        (cats) => cats,
      );

      final totalUsers = usersResult.fold(
        (failure) => 0,
        (stats) => stats.totalUsers,
      );

      // 3. Compute heavy metrics in background Isolate
      final stats = await compute(
        _computeDashboardStats,
        _DashboardComputationParams(
          orders: orders,
          products: products,
          categories: categories,
          totalUsers: totalUsers,
        ),
      );

      // 4. Update Hive cache
      await _localDataSource.cacheStats(stats.toModel());

      return Right(stats);
    } on AppException catch (e) {
      // 5. Resilient fallback to stale cache on network failure
      try {
        final fallback = await _localDataSource.getCachedStats();
        if (fallback != null) {
          return Right(fallback.toEntity());
        }
      } catch (_) {}
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e, stackTrace) {
      debugPrint('DashboardRepositoryImpl Exception: $e');
      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }
}

/// Parameter carrier class for Isolate computation
class _DashboardComputationParams {
  final List<OrderEntity> orders;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final int totalUsers;

  const _DashboardComputationParams({
    required this.orders,
    required this.products,
    required this.categories,
    required this.totalUsers,
  });
}

/// Pure computation function executing in background Isolate
DashboardStatsEntity _computeDashboardStats(_DashboardComputationParams params) {
  final orders = params.orders;
  final products = params.products;
  final categories = params.categories;
  final totalUsers = params.totalUsers;

  int pending = 0;
  int processing = 0;
  int shipped = 0;
  int delivered = 0;
  int cancelled = 0;
  double revenue = 0.0;

  for (final o in orders) {
    switch (o.status) {
      case OrderStatus.pending:
        pending++;
        break;
      case OrderStatus.processing:
        processing++;
        break;
      case OrderStatus.shipped:
        shipped++;
        break;
      case OrderStatus.delivered:
        delivered++;
        break;
      case OrderStatus.cancelled:
        cancelled++;
        break;
    }

    if (o.status != OrderStatus.cancelled) {
      revenue += o.totalAmount;
    }
  }

  int inStock = 0;
  int lowStock = 0;
  int outOfStock = 0;

  for (final p in products) {
    if (p.stockQuantity > 10) {
      inStock++;
    } else if (p.stockQuantity > 0) {
      lowStock++;
    } else {
      outOfStock++;
    }
  }

  return DashboardStatsEntity(
    totalRevenue: revenue,
    totalOrders: orders.length,
    totalUsers: totalUsers,
    totalProducts: products.length,
    orders: orders,
    products: products,
    categories: categories,
    pendingOrders: pending,
    processingOrders: processing,
    shippedOrders: shipped,
    deliveredOrders: delivered,
    cancelledOrders: cancelled,
    inStock: inStock,
    lowStock: lowStock,
    outOfStock: outOfStock,
  );
}
