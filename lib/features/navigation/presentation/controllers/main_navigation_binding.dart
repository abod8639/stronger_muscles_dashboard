import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_binding.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_binding.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_binding.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_binding.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_binding.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/controllers/users_binding.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Note: Since all feature bindings follow the same pattern, 
    // we can call them here to ensure everything is initialized 
    // for the MainNavigationScreen which uses an IndexedStack.
    
    Get.put(NavigationController(), permanent: true);
    
    AuthBinding().dependencies();
    DashboardBinding().dependencies();
    CategoriesBinding().dependencies();
    ProductsBinding().dependencies();
    PromosBinding().dependencies();
    OrdersBinding().dependencies();
    UsersBinding().dependencies();
  }
}
