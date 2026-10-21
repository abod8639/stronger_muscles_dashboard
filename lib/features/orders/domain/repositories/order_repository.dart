import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, OrderEntity>> getOrderDetails(
    String orderId, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    CancelToken? cancelToken,
  });
}
