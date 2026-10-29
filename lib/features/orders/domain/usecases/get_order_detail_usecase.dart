import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Pure Dart UseCase for retrieving order details by ID.
class GetOrderDetailUseCase {
  final OrderRepository repository;

  const GetOrderDetailUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(String id) {
    return repository.getOrderDetails(id);
  }
}
