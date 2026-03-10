import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';

void initializeServices() {
  // Core Services - Singletons
  Get.put(AuthService(), permanent: true);
  Get.put(ApiBase(), permanent: true);
  Get.put(ApiService(), permanent: true);
  Get.put(CacheService(), permanent: true);
  
  // Note: Feature-specific controllers are now handled via their respective Bindings
  // during navigation, not globally initialized here.
}
