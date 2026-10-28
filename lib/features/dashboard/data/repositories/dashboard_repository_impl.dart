import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;

  DashboardRepositoryImpl({
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
    required UserRepository userRepository,
  })  : _orderRepository = orderRepository,
        _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        _userRepository = userRepository;

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats({
    CancelToken? cancelToken,
  }) async {
    try {
      final ordersResult = await _orderRepository.getOrders();
      final productsResult = await _productRepository.getProducts();
      final categoriesResult = await _categoryRepository.getCategories();
      final usersResult = await _userRepository.getUsersStats();

      final orders = ordersResult.fold(
        (failure) {
          debugPrint('Dashboard: Orders fetch returned failure: ${failure.toMessage()}');
          return <OrderEntity>[];
        },
        (ords) => ords,
      );

      final products = productsResult.fold(
        (failure) {
          debugPrint('Dashboard: Products fetch returned failure: ${failure.toMessage()}');
          return <ProductEntity>[];
        },
        (prods) => prods,
      );

      final categories = categoriesResult.fold(
        (failure) {
          debugPrint('Dashboard: Categories fetch returned failure: ${failure.toMessage()}');
          return <CategoryEntity>[];
        },
        (cats) => cats,
      );

      final totalUsers = usersResult.fold(
        (failure) => 0,
        (stats) => stats.totalUsers,
      );

      // عزل العمليات الحسابية والتجميعية الكبيرة في Isolate خلفي لمنع تجميد الشاشة
      final stats = await compute(
        _computeDashboardStats,
        _DashboardComputationParams(
          orders: orders,
          products: products,
          categories: categories,
          totalUsers: totalUsers,
        ),
      );

      return Right(stats);
    } catch (e, stackTrace) {
      debugPrint('DashboardRepositoryImpl Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}

/// كلاس معاملات الحساب لعزله في Isolate
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

/// دالة الحساب المنفصلة التي تعمل في Isolate خلفي
DashboardStatsEntity _computeDashboardStats(_DashboardComputationParams params) {
  final orders = params.orders;
  final products = params.products;
  final categories = params.categories;
  final totalUsers = params.totalUsers;

  // 1. حساب حالات الطلبات والإيرادات
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

  // 2. إحصائيات المخزون
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
