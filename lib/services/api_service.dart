import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiService {
  static const int timeoutSeconds = 10;

  // التحقق من الاتصال بقاعدة البيانات
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('خطأ في الاتصال: $e');
      return false;
    }
  }

  // جلب جميع الطلبات
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // تحويل الاستجابة إلى قائمة
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          var data = decoded['data'];
          if (data is Map && data.containsKey('data')) {
            return data['data'] ?? [];
          }
          return data is List ? data : [];
        }
        return [];
      } else if (response.statusCode == 408) {
        throw Exception('انتهت مهلة الاتصال - تأكد من اتصالك بالإنترنت');
      } else {
        throw Exception('فشل في جلب الطلبات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب الطلبات: $e');
      rethrow;
    }
  }

  // جلب تفاصيل طلب واحد
  Future<Map<String, dynamic>> fetchOrderDetail(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}/$orderId'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب تفاصيل الطلب');
      }
    } catch (e) {
      print('خطأ في جلب تفاصيل الطلب: $e');
      rethrow;
    }
  }

  // جلب جميع المنتجات
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('data')) {
          var data = decoded['data'];
          if (data is Map && data.containsKey('data')) {
            return data['data'] ?? [];
          }
          return data is List ? data : [];
        }
        return decoded is List ? decoded : [];
      } else {
        throw Exception('فشل في جلب المنتجات');
      }
    } catch (e) {
      print('خطأ في جلب المنتجات: $e');
      rethrow;
    }
  }

  // إضافة منتج جديد
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في إضافة المنتج: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      rethrow;
    }
  }

  // تحديث منتج
  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في تحديث المنتج: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في تحديث المنتج: $e');
      rethrow;
    }
  }

  // حذف منتج
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('خطأ في حذف المنتج: $e');
      return false;
    }
  }

  // جلب جميع التصنيفات
  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('data')) {
          var data = decoded['data'];
          if (data is Map && data.containsKey('data')) {
            return data['data'] ?? [];
          }
          return data is List ? data : [];
        }
        return decoded is List ? decoded : [];
      } else {
        throw Exception('فشل في جلب التصنيفات');
      }
    } catch (e) {
      print('خطأ في جلب التصنيفات: $e');
      rethrow;
    }
  }

  // جلب ملف تعريف المستخدم
  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userProfile}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب ملف المستخدم');
      }
    } catch (e) {
      print('خطأ في جلب ملف المستخدم: $e');
      rethrow;
    }
  }

  // جلب الإحصائيات
  Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      // إذا كان لديك endpoint خاص للإحصائيات، استخدمه هنا
      // للآن، سنجلب البيانات من endpoints مختلفة
      final orders = await fetchOrders();
      final products = await fetchProducts();
      final categories = await fetchCategories();

      return {
        'orders': orders,
        'products': products,
        'categories': categories,
      };
    } catch (e) {
      print('خطأ في جلب الإحصائيات: $e');
      rethrow;
    }
  }
}
