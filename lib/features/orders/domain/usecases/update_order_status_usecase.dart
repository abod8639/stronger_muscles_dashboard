import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(
    String id,
    OrderStatus status, {
    CancelToken? cancelToken,
  }) async {
    return await repository.updateOrderStatus(
      id,
      status,
      cancelToken: cancelToken,
    );
  }
}
