import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();

    // Repositories needed for Dashboard (Fallback if not provided by other bindings)
    if (!Get.isRegistered<OrderRepository>()) {
      Get.lazyPut(() => OrderRepository(apiService), fenix: true);
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut(() => ProductRepository(apiService), fenix: true);
    }
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut(() => CategoryRepository(apiService), fenix: true);
    }
    
    // UserRepository is already provided by UsersBinding
    // Note: Ensuring DashboardRepository is registered after its dependencies
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(
        orderRepository: Get.find<OrderRepository>(),
        productRepository: Get.find<ProductRepository>(),
        categoryRepository: Get.find<CategoryRepository>(),
        userRepository: Get.find<UserRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => GetDashboardDataUseCase(Get.find<DashboardRepository>()), fenix: true);

    Get.lazyPut(
      () => DashboardController(
        getDashboardDataUseCase: Get.find<GetDashboardDataUseCase>(),
      ),
      fenix: true,
    );
  }
}
