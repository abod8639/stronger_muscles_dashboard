import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/gemini_config.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../models/ai_executive_briefing_model.dart';

abstract class GeminiDashboardRemoteDataSource {
  Future<AiExecutiveBriefingModel> generateBriefing(
    DashboardStatsEntity stats,
  );
}

class GeminiDashboardRemoteDataSourceImpl
    implements GeminiDashboardRemoteDataSource {
  final Dio _dio;

  GeminiDashboardRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<AiExecutiveBriefingModel> generateBriefing(
    DashboardStatsEntity stats,
  ) async {
    final apiKey = GeminiConfig.getApiKey();
    if (apiKey.isEmpty) {
      throw Exception(
        'مفتاح Gemini API Key غير مهيأ. يرجى إضافته أولاً من صفحة الإعدادات.',
      );
    }

    final model = GeminiConfig.getModel();
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';

    // 1. Compile low stock products for the radar
    final criticalProducts = stats.products
        .where((p) => p.stockQuantity <= 15)
        .take(15)
        .map((p) => {
              'id': p.id,
              'name': p.displayName,
              'stock': p.stockQuantity,
              'category': p.categoryId,
            })
        .toList();

    // 2. Build Category summaries if available
    final categoriesSummary = stats.categories
        .take(6)
        .map((c) => c.displayName)
        .toList()
        .join(', ');

    final prompt = '''
You are a Senior Executive Business Analyst & Supply Chain Strategist for "Stronger Muscles", a premier sports nutrition, fitness supplements, and bodybuilding e-commerce company.
Analyze the following real-time administrative dashboard metrics and generate an executive daily briefing and stock radar in fluent, professional Arabic:

=== STORE OPERATIONAL METRICS ===
- Total Revenue: ${stats.totalRevenue.toStringAsFixed(2)} IQD / Currency
- Total Orders: ${stats.totalOrders}
- Total Users: ${stats.totalUsers}
- Total Products Catalog: ${stats.totalProducts}

=== ORDER LIFECYCLE BREAKDOWN ===
- Pending Orders (Awaiting confirmation): ${stats.pendingOrders}
- Processing Orders: ${stats.processingOrders}
- Shipped Orders: ${stats.shippedOrders}
- Delivered Orders: ${stats.deliveredOrders}
- Cancelled Orders: ${stats.cancelledOrders}

=== INVENTORY HEALTH ===
- Products in Stock: ${stats.inStock}
- Products with Low Stock: ${stats.lowStock}
- Out of Stock Products: ${stats.outOfStock}

=== CRITICAL INVENTORY RADAR SAMPLES ===
${jsonEncode(criticalProducts)}

=== ACTIVE CATEGORIES ===
$categoriesSummary

CRITICAL INSTRUCTIONS:
1. Provide a sharp, professional executive summary in Arabic (2-3 sentences) evaluating today's overall commercial performance and logistics efficiency.
2. Determine business sentiment: "positive" (if revenue and fulfillment are healthy), "neutral" (steady operations), or "needs_attention" (high pending/cancelled orders or critical inventory shortages).
3. Formulate 2-3 key quantitative insights in Arabic.
4. Formulate 2-3 specific, actionable operational recommendations in Arabic for the store manager.
5. In "stock_alerts", analyze the critical inventory list and flag items that are out of stock or low with precise suggested restocking actions.

Return ONLY a valid JSON object matching this exact schema:
{
  "summary": "ملخص تنفيذي عربي احترافي ومباشر يوضح حالة المبيعات والعمليات اليوم...",
  "sentiment": "positive",
  "key_insights": [
    "نمو إيجابي في حجم المبيعات الإجمالي مع استقرار الطلبات المكتملة",
    "تراكم 5 طلبات معلقة تتطلب التدخل السريع لمنع تأخر الشحن"
  ],
  "recommendations": [
    "تأكيد وشحن الطلبات المعلقة فوراً لرفع نسبة رضا العملاء",
    "إصدار أمر توريد عاجل لمنتجات البروتين والكرياتين التي قارب مخزونها على النفاد"
  ],
  "stock_alerts": [
    {
      "product_id": "PROD-...",
      "product_name": "اسم المنتج",
      "current_stock": 2,
      "risk_level": "critical",
      "suggested_action": "طلب توريد 30 عبوة بشكل عاجل",
      "category_name": "بروتينات"
    }
  ]
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
        'temperature': 0.25,
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

    return AiExecutiveBriefingModel.fromJson(
      decoded,
      modelUsed: model,
      generatedAt: DateTime.now(),
    );
  }
}

