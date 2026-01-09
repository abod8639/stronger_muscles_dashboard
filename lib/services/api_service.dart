import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static const int timeoutSeconds = 30;

  // التحقق من الاتصال
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
      ).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // جلب الطلبات
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}'),
        headers: {'Accept': 'application/json'},
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
        throw Exception('فشل في جلب الطلبات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب الطلبات: $e');
      rethrow;
    }
  }

  // جلب تفاصيل طلب محدد
  Future<Map<String, dynamic>> fetchOrderDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.orders}/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return (decoded is Map && decoded.containsKey('data')) ? decoded['data'] : decoded;
      } else {
        throw Exception('فشل في جلب تفاصيل الطلب: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب تفاصيل الطلب: $e');
      rethrow;
    }
  }

  // جلب المنتجات
  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}'),
        headers: {'Accept': 'application/json'},
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
        throw Exception('فشل في جلب المنتجات: ${response.statusCode}');
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print('فشل إضافة المنتج. الكود: ${response.statusCode}, الرد: $errorBody');
        
        String message = 'فشل في إضافة المنتج: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values.map((e) => (e as List).join(', ')).join('; ');
          }
        } catch (_) {}
        
        throw Exception(message);
      }
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      rethrow;
    }
  }

  // تحديث منتج موجود
  Future<Map<String, dynamic>> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.products}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print('فشل تحديث المنتج. الكود: ${response.statusCode}, الرد: $errorBody');
        
        String message = 'فشل في تحديث المنتج: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values.map((e) => (e as List).join(', ')).join('; ');
          }
        } catch (_) {}
        
        throw Exception(message);
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
        headers: {'Accept': 'application/json'},
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
        headers: {'Accept': 'application/json'},
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
        throw Exception('فشل في جلب التصنيفات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب التصنيفات: $e');
      rethrow;
    }
  }

  // إضافة تصنيف جديد
  Future<Map<String, dynamic>> addCategory(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print('فشل إضافة التصنيف. الكود: ${response.statusCode}, الرد: $errorBody');
        
        String message = 'فشل في إضافة التصنيف: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values.map((e) => (e as List).join(', ')).join('; ');
          }
        } catch (_) {}
        
        throw Exception(message);
      }
    } catch (e) {
      print('خطأ في إضافة التصنيف: $e');
      rethrow;
    }
  }

  // تحديث تصنيف
  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print('فشل تحديث التصنيف. الكود: ${response.statusCode}, الرد: $errorBody');
        
        String message = 'فشل في تحديث التصنيف: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values.map((e) => (e as List).join(', ')).join('; ');
          }
        } catch (_) {}
        
        throw Exception(message);
      }
    } catch (e) {
      print('خطأ في تحديث التصنيف: $e');
      rethrow;
    }
  }

  // حذف تصنيف
  Future<bool> deleteCategory(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categories}/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('خطأ في حذف التصنيف: $e');
      return false;
    }
  }

  // رفع صورة المنتج
  Future<String> uploadProductImage(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!file.existsSync()) {
        throw Exception('الملف غير موجود: $filePath');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.uploadProductImage}'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filePath,
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('انتهت مهلة الرفع'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        print('📥 رد الخادم (uploadProductImage): $responseData');
        final decoded = json.decode(responseData);
        
        // محاولة استخراج رابط الصورة من الاستجابة
        String? imageUrl;
        
        if (decoded is Map) {
          // الحالة 1: url مباشرة
          if (decoded.containsKey('url') && decoded['url'] != null) {
            imageUrl = decoded['url'].toString();
          }
          // الحالة 2: داخل data object
          else if (decoded.containsKey('data') && decoded['data'] is Map) {
            final dataMap = decoded['data'] as Map;
            imageUrl = dataMap['url']?.toString() ?? dataMap['imageUrl']?.toString();
          }
          // الحالة 3: imageUrl مباشرة
          else if (decoded.containsKey('imageUrl') && decoded['imageUrl'] != null) {
            imageUrl = decoded['imageUrl'].toString();
          }
          // الحالة 4: path مباشرة
          else if (decoded.containsKey('path') && decoded['path'] != null) {
            imageUrl = decoded['path'].toString();
          }
        }
        
        // التحقق من أن الرابط صحيح
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // التحقق من أن الرابط يبدأ بـ http
          if (!imageUrl.startsWith('http')) {
            // إذا كان الرابط ناقصاً، أضف base URL
            imageUrl = '${ApiConfig.baseUrl}/../$imageUrl';
          }
          
          // إصلاح المنفذ إذا كان هناك عدم توافق
          if (imageUrl.contains('localhost:8000')) {
            imageUrl = imageUrl.replaceAll('localhost:8000', 'localhost:8080');
            print('🔧 تم تصحيح المنفذ من :8000 إلى :8080');
          }
          
          print('✅ رابط الصورة النهائي: $imageUrl');
          return imageUrl;
        }
        
        print('❌ لم يتم استلام رابط الصورة صحيح من الخادم');
        throw Exception('لم يتم استلام رابط الصورة من الخادم. الرد: $responseData');
      } else {
        final responseData = await response.stream.bytesToString();
        print('الخادم رد: $responseData');
        throw Exception('فشل في رفع الصورة: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في رفع الصورة: $e');
      rethrow;
    }
  }

  // رفع صورة التصنيف
  Future<String> uploadCategoryImage(String filePath) async {
    try {
      final file = File(filePath);
      
      if (!file.existsSync()) {
        throw Exception('الملف غير موجود: $filePath');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.uploadCategoryImage}'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          filePath,
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw Exception('انتهت مهلة الرفع'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        print('📥 رد الخادم (uploadCategoryImage): $responseData');
        final decoded = json.decode(responseData);
        
        // محاولة استخراج رابط الصورة من الاستجابة
        String? imageUrl;
        
        if (decoded is Map) {
          // الحالة 1: url مباشرة
          if (decoded.containsKey('url') && decoded['url'] != null) {
            imageUrl = decoded['url'].toString();
          }
          // الحالة 2: داخل data object
          else if (decoded.containsKey('data') && decoded['data'] is Map) {
            final dataMap = decoded['data'] as Map;
            imageUrl = dataMap['url']?.toString() ?? dataMap['imageUrl']?.toString();
          }
          // الحالة 3: imageUrl مباشرة
          else if (decoded.containsKey('imageUrl') && decoded['imageUrl'] != null) {
            imageUrl = decoded['imageUrl'].toString();
          }
          // الحالة 4: path مباشرة
          else if (decoded.containsKey('path') && decoded['path'] != null) {
            imageUrl = decoded['path'].toString();
          }
        }
        
        // التحقق من أن الرابط صحيح
        if (imageUrl != null && imageUrl.isNotEmpty) {
          // التحقق من أن الرابط يبدأ بـ http
          if (!imageUrl.startsWith('http')) {
            // إذا كان الرابط ناقصاً، أضف base URL
            imageUrl = '${ApiConfig.baseUrl}/../$imageUrl';
          }
          
          // إصلاح المنفذ إذا كان هناك عدم توافق
          if (imageUrl.contains('localhost:8000')) {
            imageUrl = imageUrl.replaceAll('localhost:8000', 'localhost:8080');
            print('🔧 تم تصحيح المنفذ من :8000 إلى :8080');
          }
          
          print('✅ رابط الصورة النهائي: $imageUrl');
          return imageUrl;
        }
        
        print('❌ لم يتم استلام رابط الصورة صحيح من الخادم');
        throw Exception('لم يتم استلام رابط الصورة من الخادم. الرد: $responseData');
      } else {
        throw Exception('فشل في رفع الصورة: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في رفع صورة التصنيف: $e');
      rethrow;
    }
  }

  //  flavors


  // جلب إحصائيات المستخدمين
  Future<Map<String, dynamic>> fetchUsersStats() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersStats}'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: timeoutSeconds),
        onTimeout: () => http.Response('Connection timeout', 408),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('فشل في جلب إحصائيات المستخدمين: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب إحصائيات المستخدمين: $e');
      rethrow;
    }
  }
}
