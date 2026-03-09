import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/controllers/auth_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';

void initializeServices() {
  // Core Services
  Get.put(AuthService(), permanent: true);
  Get.put(ApiBase(), permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(CacheService(), permanent: true);
  
  // Feature Controllers (Legacy support)
  Get.lazyPut(() => NavigationController(), fenix: true);
  Get.lazyPut(() => DashboardController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => ProductsController(), fenix: true);
  Get.lazyPut(() => OrdersController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
}
