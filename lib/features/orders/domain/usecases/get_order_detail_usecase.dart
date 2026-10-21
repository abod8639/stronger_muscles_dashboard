import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(
    String id, {
    CancelToken? cancelToken,
  }) async {
    return await repository.getOrderDetails(id, cancelToken: cancelToken);
  }
}
