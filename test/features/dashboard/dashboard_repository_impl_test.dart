import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/entities/user_entity.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/entities/users_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';

const testDashboardModel = DashboardStatsModel(
  totalRevenue: 2500.0,
  totalOrders: 50,
  totalUsers: 10,
  totalProducts: 20,
  pendingOrders: 5,
  processingOrders: 5,
  shippedOrders: 10,
  deliveredOrders: 25,
  cancelledOrders: 5,
  inStock: 15,
  lowStock: 3,
  outOfStock: 2,
);

class MockDashboardLocalDataSource implements DashboardLocalDataSource {
  DashboardStatsModel? cachedStats;
  bool cacheValid = false;

  @override
  Future<DashboardStatsModel?> getCachedStats() async => cachedStats;

  @override
  Future<void> cacheStats(DashboardStatsModel stats) async {
    cachedStats = stats;
    cacheValid = true;
  }

  @override
  Future<bool> isCacheValid() async => cacheValid;

  @override
  Future<void> clearCache() async {
    cachedStats = null;
    cacheValid = false;
  }
}

class MockDashboardRemoteDataSource implements DashboardRemoteDataSource {
  DashboardStatsModel? remoteStats;
  Exception? exceptionToThrow;

  @override
  Future<DashboardStatsModel> getRemoteStats() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteStats ?? testDashboardModel;
  }
}

class MockOrderRepository implements OrderRepository {
  List<OrderEntity> orders = [];
  Failure? failureToReturn;

  @override
  Future<fp.Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
  }) async {
    if (failureToReturn != null) return fp.Left(failureToReturn!);
    return fp.Right(orders);
  }

  @override
  Future<fp.Either<Failure, OrderEntity>> getOrderDetails(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<fp.Either<Failure, OrderEntity>> updateOrderStatus(String id, OrderStatus status) async {
    throw UnimplementedError();
  }
}

class MockProductRepository implements ProductRepository {
  List<ProductEntity> products = [];
  Failure? failureToReturn;

  @override
  Future<dartz.Either<Failure, List<ProductEntity>>> getProducts({
    CancelToken? cancelToken,
    bool forceRefresh = false,
  }) async {
    if (failureToReturn != null) return dartz.Left(failureToReturn!);
    return dartz.Right(products);
  }

  @override
  Future<dartz.Either<Failure, ProductEntity>> addProduct(Map<String, dynamic> data, {CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<dartz.Either<Failure, bool>> deleteProduct(String id, {CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<dartz.Either<Failure, ProductEntity>> getProductById(String id, {CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<dartz.Either<Failure, ProductEntity>> updateProduct(String id, Map<String, dynamic> data, {CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<dartz.Either<Failure, String>> uploadImage(String filePath, {CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }
}

class MockCategoryRepository implements CategoryRepository {
  List<CategoryEntity> categories = [];
  Failure? failureToReturn;

  @override
  Future<fp.Either<Failure, List<CategoryEntity>>> getCategories({
    bool forceRefresh = false,
    bool tree = false,
  }) async {
    if (failureToReturn != null) return fp.Left(failureToReturn!);
    return fp.Right(categories);
  }

  @override
  Future<fp.Either<Failure, CategoryEntity>> addCategory(CategoryEntity category) async {
    throw UnimplementedError();
  }

  @override
  Future<fp.Either<Failure, fp.Unit>> deleteCategory(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<fp.Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<fp.Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category) async {
    throw UnimplementedError();
  }
}

class MockUserRepository implements UserRepository {
  UsersStatsEntity stats = const UsersStatsEntity(
    totalUsers: 25,
    activeUsers: 20,
    inactiveUsers: 5,
    users: [],
  );
  Failure? failureToReturn;

  @override
  Future<dartz.Either<Failure, UsersStatsEntity>> getUsersStats({CancelToken? cancelToken}) async {
    if (failureToReturn != null) return dartz.Left(failureToReturn!);
    return dartz.Right(stats);
  }

  @override
  Future<dartz.Either<Failure, List<UserEntity>>> getUsers({CancelToken? cancelToken}) async {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDashboardLocalDataSource localDataSource;
  late MockDashboardRemoteDataSource remoteDataSource;
  late MockOrderRepository orderRepository;
  late MockProductRepository productRepository;
  late MockCategoryRepository categoryRepository;
  late MockUserRepository userRepository;
  late DashboardRepositoryImpl repository;

  setUp(() {
    localDataSource = MockDashboardLocalDataSource();
    remoteDataSource = MockDashboardRemoteDataSource();
    orderRepository = MockOrderRepository();
    productRepository = MockProductRepository();
    categoryRepository = MockCategoryRepository();
    userRepository = MockUserRepository();

    repository = DashboardRepositoryImpl(
      orderRepository: orderRepository,
      productRepository: productRepository,
      categoryRepository: categoryRepository,
      userRepository: userRepository,
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  });

  group('DashboardRepositoryImpl Tests', () {
    test('returns cached stats immediately when cache is valid and forceRefresh is false', () async {
      const cachedModel = testDashboardModel;
      localDataSource.cachedStats = cachedModel;
      localDataSource.cacheValid = true;

      final result = await repository.getDashboardStats(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (entity) {
          expect(entity.totalOrders, 50);
          expect(entity.totalRevenue, 2500.0);
        },
      );
    });

    test('fetches from remote data source when forceRefresh is true and caches result', () async {
      final remoteModel = DashboardStatsModel.fromJson(const {
        'total_orders': 100,
        'total_revenue': 12000.0,
        'total_users': 45,
      });
      remoteDataSource.remoteStats = remoteModel;

      final result = await repository.getDashboardStats(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (entity) {
          expect(entity.totalOrders, 100);
          expect(entity.totalRevenue, 12000.0);
        },
      );
      expect(localDataSource.cachedStats?.totalOrders, 100);
    });

    test('falls back gracefully to stale cache if remote and constituent services fail', () async {
      localDataSource.cachedStats = DashboardStatsModel.fromJson(const {
        'total_orders': 15,
        'total_revenue': 500.0,
      });
      localDataSource.cacheValid = false;
      remoteDataSource.exceptionToThrow = ServerException(message: 'Connection failed');

      final result = await repository.getDashboardStats(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right fallback, got Left: $failure'),
        (entity) {
          expect(entity.totalOrders, 15);
        },
      );
    });
  });
}
