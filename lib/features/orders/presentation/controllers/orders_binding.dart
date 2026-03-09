import 'package:get/get.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import 'orders_controller.dart';
import '../../../../data/services/api/api_base.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio));

    // Repository
    Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()));

    // Use Case
    Get.lazyPut(() => GetOrdersUseCase(Get.find<OrderRepository>()));

    // Controller
    Get.put(OrdersController(getOrdersUseCase: Get.find<GetOrdersUseCase>()));
  }
}
