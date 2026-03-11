import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/get_order_detail_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio));

    // Repository
    Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()));

    // Use Cases
    Get.lazyPut(() => GetOrdersUseCase(Get.find<OrderRepository>()));
    Get.lazyPut(() => GetOrderDetailUseCase(Get.find<OrderRepository>()));
    Get.lazyPut(() => UpdateOrderStatusUseCase(Get.find<OrderRepository>()));

    // Controller
    Get.lazyPut<OrdersController>(() => OrdersController(
      getOrdersUseCase: Get.find<GetOrdersUseCase>(),
      getOrderDetailUseCase: Get.find<GetOrderDetailUseCase>(),
      updateOrderStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
    ));
  }
}
