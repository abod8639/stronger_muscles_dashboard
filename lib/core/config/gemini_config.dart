import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';

/// Configuration and persistence manager for Google Gemini AI services.
/// Manages API keys, model selections, and live API key verification.
class GeminiConfig {
  const GeminiConfig._();

  static const String storageKeyApiKey = 'gemini_api_key';
  static const String storageKeyModel = 'gemini_selected_model';

  static const String defaultModel = 'gemini-3.5-flash';

  static const List<Map<String, String>> availableModels = [
    {
      'id': 'gemini-3.5-flash',
      'name': 'Gemini 3.5 Flash',
      'desc': 'سريع ومستقر وموصى به للمنتجات (موصى به)',
    },
    {
      'id': 'gemini-3.5-flash-lite',
      'name': 'Gemini 3.5 Flash-Lite',
      'desc': 'خفيف وفائق السرعة (< ثانية واحدة)',
    },
    {
      'id': 'gemini-3.8-flash',
      'name': 'Gemini 3.8 Flash',
      'desc': 'الجيل الأحدث مع تحليلات متقدمة',
    },
    {
      'id': 'gemini-3.7-flash',
      'name': 'Gemini 3.7 Flash',
      'desc': 'دقيق ومتوازن',
    },
  ];

  /// Reads stored Gemini API Key, with fallback to compilation environment
  static String getApiKey() {
    final storage = const GetStorage();
    final storedKey = storage.read<String>(storageKeyApiKey);
    if (storedKey != null && storedKey.trim().isNotEmpty) {
      return storedKey.trim();
    }
    return const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  }

  /// Persists Gemini API Key
  static Future<void> saveApiKey(String apiKey) async {
    final storage = const GetStorage();
    await storage.write(storageKeyApiKey, apiKey.trim());
  }

  /// Reads selected Gemini model
  static String getModel() {
    final storage = const GetStorage();
    final storedModel = storage.read<String>(storageKeyModel);
    if (storedModel != null && storedModel.trim().isNotEmpty) {
      final model = storedModel.trim();
      if (availableModels.any((m) => m['id'] == model)) {
        return model;
      }
    }
    return defaultModel;
  }

  /// Persists selected Gemini model
  static Future<void> saveModel(String model) async {
    final storage = const GetStorage();
    await storage.write(storageKeyModel, model.trim());
  }

  /// Live verification of the Gemini API Key
  static Future<({bool isValid, String message})> verifyApiKey(
    String apiKey, {
    String? model,
  }) async {
    final trimmedKey = apiKey.trim();
    if (trimmedKey.isEmpty) {
      return (isValid: false, message: 'يرجى إدخال مفتاح API أولاً');
    }

    final targetModel = model ?? getModel();
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/$targetModel:generateContent?key=$trimmedKey';

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await dio.post(
        url,
        data: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Ping test. Reply with word OK.'},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        return (isValid: true, message: 'المفتاح صالح وفعال بنجاح!');
      }

      return (
        isValid: false,
        message: 'استجابة غير متوقعة من خادم Gemini (${response.statusCode})',
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;
        String serverMsg = '';
        if (errorData is Map && errorData['error'] is Map) {
          serverMsg = errorData['error']['message'] ?? '';
        }

        if (statusCode == 400 || statusCode == 403) {
          return (
            isValid: false,
            message: 'مفتاح API غير صالح أو منتهي الصلاحية: $serverMsg',
          );
        } else if (statusCode == 404) {
          return (
            isValid: false,
            message: 'النموذج المحدد ($targetModel) غير متوفر في حسابك أو تقاعد من Google: $serverMsg',
          );
        } else if (statusCode == 429) {
          return (
            isValid: false,
            message: 'تم تجاوز حصة الاستخدام المتاحة لهذا المفتاح (Rate Limit)',
          );
        } else if (statusCode == 503) {
          return (
            isValid: false,
            message: 'خادم النموذج ($targetModel) يواجه ضغطاً مؤقتاً (503). جرب نموذج Gemini 3.5 Flash-Lite أو أعد المحاولة.',
          );
        }
        return (
          isValid: false,
          message: 'خطأ من خادم Gemini ($statusCode): $serverMsg',
        );
      }
      return (
        isValid: false,
        message: 'تعذر الاتصال بالخادم. تحقق من اتصال الإنترنت: ${e.message}',
      );
    } catch (e) {
      return (isValid: false, message: 'حدث خطأ أثناء فحص المفتاح: $e');
    }
  }
}

