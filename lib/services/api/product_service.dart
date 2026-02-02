import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'api_base.dart';

class ProductService extends ApiBase {
  // جلب المنتجات (Admin)
  Future<List<dynamic>> fetchProducts() async {
    try {
      List<dynamic> allProducts = [];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await http
            .get(
              Uri.parse(
                '${ApiConfigController().baseUrl.value}${ApiConfig.adminProducts}?page=$currentPage',
              ),
              headers: getAuthHeaders(),
            )
            .timeout(
              const Duration(seconds: ApiBase.timeoutSeconds),
              onTimeout: () => http.Response('Connection timeout', 408),
            );

        // Handle auth errors
        handleAuthErrors(response);

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          List<dynamic> pageItems = [];

          if (decoded is Map) {
            // استخراج معلومات الصفحات (Pagination)
            if (decoded.containsKey('meta') && decoded['meta'] is Map) {
              final meta = decoded['meta'];
              if (meta.containsKey('last_page')) {
                lastPage = meta['last_page'];
              }
            } else if (decoded.containsKey('last_page')) {
              lastPage = decoded['last_page'];
            }

            // استخراج البيانات
            if (decoded.containsKey('data')) {
              var data = decoded['data'];
              if (data is List) {
                pageItems = data;
              } else if (data is Map &&
                  data.containsKey('data') &&
                  data['data'] is List) {
                pageItems = data['data'];

                // حالة خاصة: أحياناً تكون معلومات الصفحات داخل الكائن data
                if (data.containsKey('last_page')) {
                  lastPage = data['last_page'];
                } else if (data.containsKey('meta') && data['meta'] is Map) {
                  final meta = data['meta'];
                  if (meta.containsKey('last_page')) {
                    lastPage = meta['last_page'];
                  }
                }
              }
            }
          } else if (decoded is List) {
            // في حال كانت الاستجابة قائمة مباشرة بدون صفحات
            pageItems = decoded;
            lastPage = 1;
          }

          allProducts.addAll(pageItems);

          // التحقق إذا لم يكن هناك صفحات (لتجنب الحلقات اللانهائية في حال الخطأ)
          if (decoded is! Map ||
              (!decoded.containsKey('meta') && !decoded.containsKey('links'))) {
            // إذا لم نجد مؤشرات للصفحات، نفترض أنها صفحة واحدة فقط
            if (currentPage == 1 && lastPage == 1) {
              // keep default
            } else {
              // إذا لم نجد meta ولكن قمنا بزيادة lastPage سابقاً، نستمر
            }
          }
        } else {
          throw Exception(
            'فشل في جلب المنتجات (صفحة $currentPage): ${response.statusCode}',
          );
        }

        currentPage++;
      } while (currentPage <= lastPage);

      return allProducts;
    } catch (e) {
      print('خطأ في جلب المنتجات: $e');
      rethrow;
    }
  }

  // إضافة منتج جديد (Admin)
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminProducts}',
            ),
            headers: getAuthHeaders(),
            body: json.encode(data),
          )
          .timeout(
            const Duration(seconds: ApiBase.timeoutSeconds),
            onTimeout: () => http.Response('Connection timeout', 408),
          );

      // Handle auth errors
      handleAuthErrors(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print(
          'فشل إضافة المنتج. الكود: ${response.statusCode}, الرد: $errorBody',
        );

        String message = 'فشل في إضافة المنتج: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values
                .map((e) => (e as List).join(', '))
                .join('; ');
          }
        } catch (_) {}

        throw Exception(message);
      }
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      rethrow;
    }
  }

  // تحديث منتج موجود (Admin)
  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminProductDetail(id)}',
            ),
            headers: getAuthHeaders(),
            body: json.encode(data),
          )
          .timeout(
            const Duration(seconds: ApiBase.timeoutSeconds),
            onTimeout: () => http.Response('Connection timeout', 408),
          );

      // Handle auth errors
      handleAuthErrors(response);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorBody = response.body;
        print(
          'فشل تحديث المنتج. الكود: ${response.statusCode}, الرد: $errorBody',
        );

        String message = 'فشل في تحديث المنتج: ${response.statusCode}';
        try {
          final decoded = json.decode(errorBody);
          if (decoded is Map && decoded.containsKey('message')) {
            message = decoded['message'];
          } else if (decoded is Map && decoded.containsKey('errors')) {
            final errors = decoded['errors'] as Map;
            message = errors.values
                .map((e) => (e as List).join(', '))
                .join('; ');
          }
        } catch (_) {}

        throw Exception(message);
      }
    } catch (e) {
      print('خطأ في تحديث المنتج: $e');
      rethrow;
    }
  }

  // حذف منتج (Admin)
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http
          .delete(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminProductDetail(id)}',
            ),
            headers: getAuthHeaders(),
          )
          .timeout(
            const Duration(seconds: ApiBase.timeoutSeconds),
            onTimeout: () => http.Response('Connection timeout', 408),
          );

      // Handle auth errors
      handleAuthErrors(response);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('خطأ في حذف المنتج: $e');
      return false;
    }
  }

  // رفع صورة المنتج (Admin)
  Future<String> uploadProductImage(String filePath) async {
    try {
      final file = File(filePath);

      if (!file.existsSync()) {
        throw Exception('الملف غير موجود: $filePath');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ApiConfigController().baseUrl.value}${ApiConfig.adminUploadProductImage}',
        ),
      );

      // Add auth headers
      request.headers.addAll(getAuthHeaders());

      request.files.add(await http.MultipartFile.fromPath('image', filePath));

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
            imageUrl =
                dataMap['url']?.toString() ?? dataMap['imageUrl']?.toString();
          }
          // الحالة 3: imageUrl مباشرة
          else if (decoded.containsKey('imageUrl') &&
              decoded['imageUrl'] != null) {
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
            imageUrl = '${ApiConfigController().baseUrl.value}/../$imageUrl';
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
        throw Exception(
          'لم يتم استلام رابط الصورة من الخادم. الرد: $responseData',
        );
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
}
