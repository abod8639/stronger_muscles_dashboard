import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_binding.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_binding.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:stronger_muscles_dashboard/features/notifications/presentation/controllers/notifications_binding.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_binding.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_binding.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_binding.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/controllers/users_binding.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/controllers/support_binding.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NavigationController>()) {
      Get.put<NavigationController>(NavigationController(), permanent: true);
    }
    
    AuthBinding().dependencies();
    DashboardBinding().dependencies();
    CategoriesBinding().dependencies();
    ProductsBinding().dependencies();
    PromosBinding().dependencies();
    OrdersBinding().dependencies();
    UsersBinding().dependencies();
    NotificationsBinding().dependencies();
    SupportBinding().dependencies();
  }
}
