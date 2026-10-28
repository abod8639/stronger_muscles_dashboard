import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

/// Pure Dart UseCase for modifying order status.
class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  const UpdateOrderStatusUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call(
    String id,
    OrderStatus status,
  ) {
    return repository.updateOrderStatus(
      id,
      status,
    );
  }
}
