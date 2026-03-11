import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/network/api/user_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/data/datasources/user_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/users/data/repositories/user_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final apiService = Get.find<ApiService>();
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Repositories needed for Dashboard (Fallback if not provided by other bindings)
    
    // Orders
    if (!Get.isRegistered<OrderRemoteDataSource>()) {
      Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio), fenix: true);
    }
    if (!Get.isRegistered<OrderRepository>()) {
      Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()), fenix: true);
    }

    // Products (Already concrete, just ensure it's registered)
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(() => ProductRepository(apiService), fenix: true);
    }

    // Categories (Already concrete, just ensure it's registered)
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut<CategoryRepository>(() => CategoryRepository(apiService), fenix: true);
    }

    // Users
    if (!Get.isRegistered<UserService>()) {
      Get.lazyPut(() => UserService(), fenix: true);
    }
    if (!Get.isRegistered<UserRemoteDataSource>()) {
      Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(Get.find<UserService>()), fenix: true);
    }
    if (!Get.isRegistered<UserRepository>()) {
      Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserRemoteDataSource>()), fenix: true);
    }
    
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
