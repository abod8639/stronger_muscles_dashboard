import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/auth_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';
import 'package:stronger_muscles_dashboard/data/services/cache_service.dart';

void initializeServices() {
  Get.put(CacheService(), permanent: true);
  Get.lazyPut(() => NavigationController(), fenix: true);
  Get.lazyPut(() => DashboardController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => ProductsController(), fenix: true);
  Get.lazyPut(() => OrdersController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
}