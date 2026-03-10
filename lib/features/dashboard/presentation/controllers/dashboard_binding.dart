import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import '../../../../core/network/api_base.dart';
import '../../../categories/data/datasources/category_remote_datasource.dart';
// import '../../../categories/domain/repositories/category_repository.dart';
// import '../../../categories/domain/usecases/add_category_usecase.dart';
import '../../../categories/domain/usecases/delete_category_usecase.dart';
// import '../../../categories/domain/usecases/get_categories_usecase.dart';
// import '../../../categories/domain/usecases/update_category_usecase.dart';
// import '../../../categories/presentation/controllers/categories_controller.dart';
import '../../../orders/data/datasources/order_remote_datasource.dart';
// import '../../../orders/data/repositories/order_repository_impl.dart';
// import '../../../orders/domain/repositories/order_repository.dart';
// import '../../../orders/domain/usecases/get_order_detail_usecase.dart';
// import '../../../orders/domain/usecases/get_orders_usecase.dart';
// import '../../../orders/domain/usecases/update_order_status_usecase.dart';
import '../../../orders/presentation/controllers/orders_controller.dart';
import '../../../products/data/datasources/product_remote_datasource.dart';
// import '../../../products/domain/repositories/product_repository.dart';
import '../../../users/data/datasources/user_remote_datasource.dart';
import '../../../users/data/repositories/user_repository_impl.dart';
import '../../../users/domain/repositories/user_repository.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(dio), fenix: true);
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio), fenix: true);
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio), fenix: true);
    Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio), fenix: true);

    // Repositories
    // Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find<CategoryRemoteDataSource>()), fenix: true);
    // Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()), fenix: true);
    // Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserRemoteDataSource>()), fenix: true);
    
    // Categories UseCases
    // Get.lazyPut(() => GetCategoriesUseCase(Get.find<CategoryRepository>()), fenix: true);
    // Get.lazyPut(() => AddCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);
    // Get.lazyPut(() => UpdateCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);
    Get.lazyPut(() => DeleteCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);

    // Orders UseCases
    // Get.lazyPut(() => GetOrdersUseCase(Get.find<OrderRepository>()), fenix: true);
    // Get.lazyPut(() => GetOrderDetailUseCase(Get.find<OrderRepository>()), fenix: true);
    // Get.lazyPut(() => UpdateOrderStatusUseCase(Get.find<OrderRepository>()), fenix: true);

    // Controllers
    // Get.lazyPut(() => CategoriesController(
    //   // getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
    //   // addCategoryUseCase: Get.find<AddCategoryUseCase>(),
    //   // updateCategoryUseCase: Get.find<UpdateCategoryUseCase>(),
    //   deleteCategoryUseCase: Get.find<DeleteCategoryUseCase>(),
    // ), fenix: true);

    Get.lazyPut(() => OrdersController(
      // getOrdersUseCase: Get.find<GetOrdersUseCase>(),
      // getOrderDetailUseCase: Get.find<GetOrderDetailUseCase>(),
      // updateOrderStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
    ), fenix: true);

    Get.put(DashboardController());
    Get.put(NavigationController());
  }
}
