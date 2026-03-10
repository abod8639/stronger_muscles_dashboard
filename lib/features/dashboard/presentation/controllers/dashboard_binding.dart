import 'package:get/get.dart';
import '../../../../core/network/api_base.dart';
import '../../../categories/data/datasources/category_remote_datasource.dart';
import '../../../categories/data/repositories/category_repository_impl.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../orders/data/datasources/order_remote_datasource.dart';
import '../../../orders/data/repositories/order_repository_impl.dart';
import '../../../orders/domain/repositories/order_repository.dart';
import '../../../products/data/datasources/product_remote_datasource.dart';
import '../../../products/data/repositories/product_repository_impl.dart';
import '../../../products/domain/repositories/product_repository.dart';
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
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(dio));
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio));
    Get.lazyPut<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(dio));
    Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(dio));

    // Repositories
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find<CategoryRemoteDataSource>()));
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()));
    Get.lazyPut<OrderRepository>(() => OrderRepositoryImpl(Get.find<OrderRemoteDataSource>()));
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserRemoteDataSource>()));

    // Controller
    Get.put(DashboardController());
  }
}
