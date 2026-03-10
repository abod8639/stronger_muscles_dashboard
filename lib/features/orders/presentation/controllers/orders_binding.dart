import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
// import '../../domain/repositories/order_repository.dart';
// import '../../domain/usecases/get_orders_usecase.dart';
// import '../../domain/usecases/get_order_detail_usecase.dart';
// import '../../domain/usecases/update_order_status_usecase.dart';
import '../../data/datasources/order_remote_datasource.dart';
// import '../../data/repositories/order_repository_impl.dart';
import 'orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio));

    // Repository
    // Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()));

    // Use Cases
    // Get.lazyPut(() => GetOrdersUseCase(Get.find<OrderRepository>()));
    // Get.lazyPut(() => GetOrderDetailUseCase(Get.find<OrderRepository>()));
    // Get.lazyPut(() => UpdateOrderStatusUseCase(Get.find<OrderRepository>()));

    // Controller
    Get.put(OrdersController(
      // getOrdersUseCase: Get.find<GetOrdersUseCase>(),
      // getOrderDetailUseCase: Get.find<GetOrderDetailUseCase>(),
      // updateOrderStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
    ));
  }
}
