import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Pure Dart UseCase for retrieving customer orders list.
class GetOrdersUseCase {
  final OrderRepository repository;

  const GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    bool forceRefresh = false,
  }) {
    return repository.getOrders(
      forceRefresh: forceRefresh,
    );
  }
}
