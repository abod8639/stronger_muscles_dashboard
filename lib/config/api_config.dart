class ApiConfig {
  // الرابط الأساسي (Base URL)
  static const String baseUrl = 'http://localhost:8080/api/v1'; 
  
  // ملاحظة: للهاتف الحقيقي استخدم IP الجهاز، وللمحاكي (Android Emulator) استخدم 10.0.2.2
  // static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // روابط المنتجات
  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';
  static const String uploadProductImage = '/upload/product-image';

  // روابط التصنيفات
  static const String categories = '/categories';
  static const String uploadCategoryImage = '/upload/category-image';

  // روابط الطلبات
  static const String orders = '/orders';

  // روابط المستخدم والحساب
  static const String userProfile = '/user'; // يتطلب Token
  static const String login = '/login';
  static const String register = '/register';

  // روابط الرفع العامة
  static const String uploadFile = '/upload';
  static const String uploadImage = '/upload/image';
}