import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/gemini_config.dart';
import '../models/ai_product_suggestion_model.dart';

abstract class GeminiProductRemoteDataSource {
  Future<AiProductSuggestionModel> generateProductDetails({
    required String productName,
    List<String>? availableCategories,
    List<String>? availableBrands,
  });
}

class GeminiProductRemoteDataSourceImpl
    implements GeminiProductRemoteDataSource {
  final Dio _dio;

  GeminiProductRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<AiProductSuggestionModel> generateProductDetails({
    required String productName,
    List<String>? availableCategories,
    List<String>? availableBrands,
  }) async {
    final apiKey = GeminiConfig.getApiKey();
    if (apiKey.isEmpty) {
      throw Exception(
        'مفتاح Gemini API Key غير مهيأ. يرجى إضافته أولاً من صفحة الإعدادات.',
      );
    }

    final model = GeminiConfig.getModel();
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';

    final categoriesContext = availableCategories != null &&
            availableCategories.isNotEmpty
        ? 'Available store categories to match: ${availableCategories.join(', ')}.'
        : '';

    final brandsContext = availableBrands != null && availableBrands.isNotEmpty
        ? 'Existing brands in database: ${availableBrands.join(', ')}.'
        : '';

    final prompt = '''
You are an expert sports nutrition, fitness supplements, and bodybuilding product database curator.
The user wants to catalog this product: "$productName".

Generate accurate, professional, and authentic product information.
$categoriesContext
$brandsContext

Return ONLY a valid JSON object matching this exact schema:
{
  "name_ar": "اسم المنتج الاحترافي بالعربية متضمناً الشركة ونوع المكمل",
  "name_en": "Official English Product Name with Brand",
  "desc_ar": "وصف تسويقي دقيق بالعربية يشمل أهم الفوائد، المكونات الأساسية، وطريقة الاستخدام",
  "desc_en": "Professional marketing description in English",
  "brand": "Manufacturer Brand Name (e.g. Optimum Nutrition, Dymatize, Muscletech, etc.)",
  "suggested_category": "Best matching category name",
  "serving_size": "e.g. 30g (1 Scoop)",
  "servings_per_container": 60,
  "nutrition_facts": {
    "calories": "e.g. 120",
    "protein": "e.g. 24g",
    "carbs": "e.g. 3g",
    "fat": "e.g. 1.5g",
    "sugar": "e.g. 1g"
  },
  "allergens": ["حليب", "صويا"],
  "tags": ["واي بروتين", "بروتين", "استشفاء عضلي", "عضلات صافية"],
  "flavors": ["شوكولاتة دبل ريتش | Double Rich Chocolate", "فانيليا آيس كريم | Vanilla Ice Cream", "فراولة لذيذة | Strawberry"],
  "suggested_sizes": [
    {"size": "2 Lbs", "weight": "907g", "servings": 29},
    {"size": "5 Lbs", "weight": "2.27kg", "servings": 73}
  ],
  "sku_prefix": "e.g. ON-GSW"
}
''';

    final body = {
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
      'generationConfig': {
        'response_mime_type': 'application/json',
        'temperature': 0.2,
      },
    };

    final response = await _dio.post(
      url,
      data: jsonEncode(body),
      options: Options(
        headers: {'Content-Type': 'application/json'},
        sendTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('خطأ من خادم Gemini (${response.statusCode})');
    }

    final data = response.data;
    if (data is! Map) {
      throw Exception('استجابة غير صالحة من خادم Gemini');
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw Exception('لم يُرجع نموذج الذكاء الاصطناعي أي استجابة');
    }

    final content = candidates.first['content'];
    final parts = content?['parts'];
    if (parts is! List || parts.isEmpty) {
      throw Exception('المحتوى المسترجع فارغ');
    }

    String rawText = parts.first['text']?.toString() ?? '';
    rawText = rawText.trim();

    // Clean any markdown fences if present
    if (rawText.startsWith('```json')) {
      rawText = rawText.substring(7);
    } else if (rawText.startsWith('```')) {
      rawText = rawText.substring(3);
    }
    if (rawText.endsWith('```')) {
      rawText = rawText.substring(0, rawText.length - 3);
    }
    rawText = rawText.trim();

    final decoded = jsonDecode(rawText);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('صيغة البيانات المسترجعة ليست JSON صالحاً');
    }

    return AiProductSuggestionModel.fromJson(decoded);
  }
}

