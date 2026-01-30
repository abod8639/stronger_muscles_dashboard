import 'package:http/http.dart' as http;
import 'api/api_base.dart';
import 'api/category_service.dart';
import 'api/order_service.dart';
import 'api/product_service.dart';
import 'api/user_service.dart';

class ApiService {
  static const int timeoutSeconds = ApiBase.timeoutSeconds;
  
  final ApiBase _apiBase = ApiBase();
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();

  // Helper method to get authenticated headers
  Map<String, String> _getAuthHeaders() {
    return _apiBase.getAuthHeaders();
  }

  // Handle authentication errors
  void _handleAuthErrors(http.Response response) {
    _apiBase.handleAuthErrors(response);
  }

  // التحقق من الاتصال
  Future<bool> checkConnection() async {
    return _apiBase.checkConnection();
  }

  // جلب الطلبات (Admin)
  Future<List<dynamic>> fetchOrders() {
    return _orderService.fetchOrders();
  }

  // جلب تفاصيل طلب محدد (Admin)
  Future<Map<String, dynamic>> fetchOrderDetail(String id) {
    return _orderService.fetchOrderDetail(id);
  }

  // جلب المنتجات (Admin)
  Future<List<dynamic>> fetchProducts() {
    return _productService.fetchProducts();
  }

  // إضافة منتج جديد (Admin)
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) {
    return _productService.addProduct(data);
  }

  // تحديث منتج موجود (Admin)
  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) {
    return _productService.updateProduct(id, data);
  }

  // حذف منتج (Admin)
  Future<bool> deleteProduct(String id) {
    return _productService.deleteProduct(id);
  }

  // جلب جميع التصنيفات (Public)
  Future<List<dynamic>> fetchCategories() {
    return _categoryService.fetchCategories();
  }

  // إضافة تصنيف جديد
  Future<Map<String, dynamic>> addCategory(Map<String, dynamic> data) {
    return _categoryService.addCategory(data);
  }

  // تحديث تصنيف
  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> data) {
    return _categoryService.updateCategory(id, data);
  }

  // حذف تصنيف
  Future<bool> deleteCategory(String id) {
    return _categoryService.deleteCategory(id);
  }

  // رفع صورة المنتج (Admin)
  Future<String> uploadProductImage(String filePath) {
    return _productService.uploadProductImage(filePath);
  }

  // رفع صورة التصنيف (Admin)
  Future<String> uploadCategoryImage(String filePath) {
    return _categoryService.uploadCategoryImage(filePath);
  }

  // جلب إحصائيات المستخدمين (Admin)
  Future<Map<String, dynamic>> fetchUsersStats() {
    return _userService.fetchUsersStats();
  }
}
