import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderDetailUseCase {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  Future<OrderEntity> call(String id) async {
    return await repository.getOrderById(id);
  }
}
