import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

class MockOrderRemoteDataSource implements OrderRemoteDataSource {
  List<OrderModel>? mockOrders;
  OrderModel? mockOrder;
  Exception? exceptionToThrow;

  @override
  Future<List<OrderModel>> getOrders({CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockOrders ?? [];
  }

  @override
  Future<OrderModel> getOrderById(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockOrder!;
  }

  @override
  Future<OrderModel> updateOrderStatus(
    String id,
    OrderStatus status, {
    CancelToken? cancelToken,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockOrder!.copyWith(status: status);
  }
}

class MockOrderLocalDataSource implements OrderLocalDataSource {
  List<OrderModel> storedOrders = [];
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedOrders;
  }

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedOrders = List.from(orders);
    cacheValid = true;
  }

  @override
  Future<OrderModel?> getCachedOrderById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    try {
      return storedOrders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheOrder(OrderModel order) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = storedOrders.indexWhere((o) => o.id == order.id);
    if (index >= 0) {
      storedOrders[index] = order;
    } else {
      storedOrders.add(order);
    }
  }

  @override
  Future<void> clearCache() async {
    storedOrders.clear();
    cacheValid = false;
  }

  @override
  Future<bool> isCacheValid() async {
    return cacheValid;
  }
}

void main() {
  late MockOrderRemoteDataSource mockRemoteDataSource;
  late MockOrderLocalDataSource mockLocalDataSource;
  late OrderRepositoryImpl repository;

  final testOrderModel = OrderModel(
    id: 'ord-1',
    userId: 'u-1',
    orderDate: DateTime(2026, 1, 1),
    status: OrderStatus.pending,
    paymentStatus: PaymentStatus.paid,
    paymentMethod: 'card',
    addressId: 'addr-1',
    subtotal: 100.0,
    shippingCost: 10.0,
    discount: 0.0,
    totalAmount: 110.0,
  );

  setUp(() {
    mockRemoteDataSource = MockOrderRemoteDataSource();
    mockLocalDataSource = MockOrderLocalDataSource();
    repository = OrderRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('OrderRepositoryImpl.getOrders', () {
    test('returns cached orders when cache is valid and forceRefresh is false', () async {
      mockLocalDataSource.storedOrders = [testOrderModel];
      mockLocalDataSource.cacheValid = true;

      final result = await repository.getOrders(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected right'),
        (orders) {
          expect(orders.length, 1);
          expect(orders.first.id, 'ord-1');
        },
      );
    });

    test('fetches from remote and updates cache when forceRefresh is true', () async {
      mockRemoteDataSource.mockOrders = [testOrderModel];

      final result = await repository.getOrders(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected right'),
        (orders) {
          expect(orders.length, 1);
          expect(orders.first.id, 'ord-1');
        },
      );
      expect(mockLocalDataSource.storedOrders.length, 1);
    });

    test('falls back to cache when remote fails and cached data exists', () async {
      mockLocalDataSource.storedOrders = [testOrderModel];
      mockLocalDataSource.cacheValid = false;
      mockRemoteDataSource.exceptionToThrow = const ServerException(
        message: 'Server error',
        statusCode: 500,
      );

      final result = await repository.getOrders(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected right fallback'),
        (orders) {
          expect(orders.length, 1);
          expect(orders.first.id, 'ord-1');
        },
      );
    });

    test('returns Left(Failure) when remote fails and cache is empty', () async {
      mockLocalDataSource.storedOrders = [];
      mockRemoteDataSource.exceptionToThrow = const ServerException(
        message: 'Server offline',
        statusCode: 503,
      );

      final result = await repository.getOrders(forceRefresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (orders) => fail('Expected left failure'),
      );
    });
  });

  group('OrderRepositoryImpl.updateOrderStatus', () {
    test('updates status remotely, updates local cache and returns updated entity', () async {
      mockRemoteDataSource.mockOrder = testOrderModel;

      final result = await repository.updateOrderStatus('ord-1', OrderStatus.shipped);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected right'),
        (order) {
          expect(order.status, OrderStatus.shipped);
        },
      );
      expect(mockLocalDataSource.storedOrders.first.status, OrderStatus.shipped);
    });
  });
}
