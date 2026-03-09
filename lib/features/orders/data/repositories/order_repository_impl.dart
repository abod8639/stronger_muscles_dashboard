import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<OrderEntity>> getOrders() async {
    return await remoteDataSource.getOrders();
  }

  @override
  Future<OrderEntity> getOrderById(String id) async {
    return await remoteDataSource.getOrderById(id);
  }

  @override
  Future<OrderEntity> updateOrderStatus(String id, OrderStatus status) async {
    return await remoteDataSource.updateOrderStatus(id, status);
  }
}
