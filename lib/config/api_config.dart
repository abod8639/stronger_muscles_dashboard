
import 'package:get/get.dart';

class ApiConfigController extends GetxController {
  
  // ملاحظة: للهاتف الحقيقي استخدم IP الجهاز، وللمحاكي (Android Emulator) استخدم 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';
  // RxString baseUrl  = 'http://192.168.1.17:8080/api/v1'.obs;

  RxString baseUrl = 'http://localhost:8080/api/v1'.obs;

}
  


class ApiConfig {
  // ==================== Authentication Endpoints ====================
  static const String login = '/auth/login';
  static const String googleSignIn = '/auth/google-signin';
  static const String updateProfile = '/auth/update-profile';

  // ==================== Public Shop Endpoints ====================
  static const String shopCategories = '/shop/categories';
  static String shopCategoryDetail(String id) => '/shop/categories/$id';
  
  static const String shopProducts = '/shop/products';
  static String shopProductDetail(String id) => '/shop/products/$id';

  // ==================== Admin Endpoints (Protected) ====================
  
  // Products Management
  static const String adminProducts = '/admin/products';
  static String adminProductDetail(String id) => '/admin/products/$id';
  
  // Orders Management
  static const String adminOrders = '/admin/orders';
  static String adminOrderDetail(String id) => '/admin/orders/$id';
  
  // Users Management
  static const String adminUsers = '/admin/users';
  
  // Image Uploads
  static const String adminUploadProductImage = '/admin/upload/product-image';
  static const String adminUploadCategoryImage = '/admin/upload/category-image';

  // ==================== Customer Endpoints (Protected) ====================
  static const String customerProfile = '/customer/profile';
  static const String customerCart = '/customer/cart';
  static const String customerOrders = '/customer/orders';

  // ==================== Legacy/Deprecated (for backward compatibility) ====================
  // These are kept for backward compatibility but should be migrated to new endpoints
  @Deprecated('Use shopProducts instead')
  static const String products = '/shop/products';
  
  @Deprecated('Use shopCategories instead')
  static const String categories = '/shop/categories';
  
  @Deprecated('Use adminOrders instead')
  static const String orders = '/admin/orders';
  
  @Deprecated('Use adminUsers instead')
  static const String usersStats = '/admin/users';
  
  @Deprecated('Use adminUploadProductImage instead')
  static const String uploadProductImage = '/admin/upload/product-image';
  
  @Deprecated('Use adminUploadCategoryImage instead')
  static const String uploadCategoryImage = '/admin/upload/category-image';
}