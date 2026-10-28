import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/order_entity.dart';

/// Pure Dart Domain Contract for Orders repository.
/// 100% decoupled from Dio, Hive, or Flutter UI frameworks.
abstract class OrderRepository {
  /// Fetches orders list with optional cache bypass.
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
  });

  /// Fetches detailed order information by unique identifier.
  Future<Either<Failure, OrderEntity>> getOrderDetails(
    String orderId,
  );

  /// Updates the status of an existing order.
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  );
}
