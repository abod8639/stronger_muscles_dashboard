import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    return await repository.getOrders(
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );
  }
}
