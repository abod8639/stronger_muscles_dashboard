import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/gemini_config.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
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

    // 1. Calculate actual customer sales per product from valid orders (non-cancelled)
    final Map<String, int> productUnitsSold = {};
    final Map<String, int> productOrdersCount = {};
    final Map<String, double> productRevenueMap = {};

    for (final order in stats.orders) {
      if (order.status == OrderStatus.cancelled) continue;
      for (final item in order.items) {
        final id = item.productId.trim();
        final name = item.productName.trim().toLowerCase();

        productUnitsSold[id] = (productUnitsSold[id] ?? 0) + item.quantity;
        productOrdersCount[id] = (productOrdersCount[id] ?? 0) + 1;
        productRevenueMap[id] = (productRevenueMap[id] ?? 0.0) + item.subtotal;

        if (name.isNotEmpty) {
          productUnitsSold['name:$name'] =
              (productUnitsSold['name:$name'] ?? 0) + item.quantity;
          productOrdersCount['name:$name'] =
              (productOrdersCount['name:$name'] ?? 0) + 1;
        }
      }
    }

    // 2. Map category names and calculate category actual sales
    final Map<String, String> categoryNameMap = {
      for (final c in stats.categories) c.id: c.displayName,
    };

    final Map<String, int> categoryUnitsSold = {};
    for (final product in stats.products) {
      final sold = productUnitsSold[product.id] ??
          productUnitsSold['name:${product.displayName.trim().toLowerCase()}'] ??
          0;
      if (sold > 0 && product.categoryId.isNotEmpty) {
        final catName = categoryNameMap[product.categoryId] ?? product.categoryId;
        categoryUnitsSold[catName] = (categoryUnitsSold[catName] ?? 0) + sold;
      }
    }

    // 3. Separate products with actual customer sales from zero-sales products
    final totalCatalogProducts = stats.products.length;
    final soldProductsList = <Map<String, dynamic>>[];
    int zeroSalesProductsCount = 0;

    for (final p in stats.products) {
      final unitsSold = productUnitsSold[p.id] ??
          productUnitsSold['name:${p.displayName.trim().toLowerCase()}'] ??
          0;
      final ordersCount = productOrdersCount[p.id] ??
          productOrdersCount['name:${p.displayName.trim().toLowerCase()}'] ??
          0;
      final revenue = productRevenueMap[p.id] ?? 0.0;

      if (unitsSold > 0) {
        soldProductsList.add({
          'name': p.displayName,
          'units_sold': unitsSold,
          'orders_count': ordersCount,
          'revenue': revenue,
          'current_stock': p.stockQuantity,
        });
      } else {
        zeroSalesProductsCount++;
      }
    }
    soldProductsList.sort(
      (a, b) => (b['units_sold'] as int).compareTo(a['units_sold'] as int),
    );

    // 4. Compile low stock products for the radar with verified sales metrics
    final criticalProducts = stats.products
        .where((p) => p.stockQuantity <= 15)
        .take(15)
        .map((p) {
          final unitsSold = productUnitsSold[p.id] ??
              productUnitsSold['name:${p.displayName.trim().toLowerCase()}'] ??
              0;
          final ordersCount = productOrdersCount[p.id] ??
              productOrdersCount['name:${p.displayName.trim().toLowerCase()}'] ??
              0;
          final catName = categoryNameMap[p.categoryId] ?? p.categoryId;

          return {
            'id': p.id,
            'name': p.displayName,
            'current_stock': p.stockQuantity,
            'category': catName,
            'units_sold': unitsSold,
            'orders_count': ordersCount,
            'has_been_ordered_by_customers': unitsSold > 0,
            'reality_note': unitsSold > 0
                ? 'تم بيع $unitsSold وحدة عبر $ordersCount طلب فعلي'
                : 'صفر مبيعات (لم يسبق لأي عميل طلب هذا المنتج إطلاقاً. المخزون منخفض فقط بسبب كمية الإدخال المبدئية في النظام وليس بسبب المبيعات)',
          };
        })
        .toList();

    // 5. Build Category summaries
    final categoriesSummary = stats.categories
        .take(6)
        .map((c) => c.displayName)
        .toList()
        .join(', ');

    final prompt = '''
You are a Senior Executive Business Analyst & Supply Chain Strategist for "Stronger Muscles", a premier sports nutrition, fitness supplements, and bodybuilding e-commerce platform.
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

=== REAL VERIFIED SALES & CUSTOMER DEMAND (GROUND TRUTH) ===
- Best-Selling Products (Actually ordered by customers):
${soldProductsList.isEmpty ? "لا توجد أي مبيعات فعلية لأي منتج حتى الآن (جميع المنتجات مبيعاتها صفر)." : jsonEncode(soldProductsList.take(6).toList())}
- Products with Zero Orders (لم يطلبها أي عميل إطلاقاً): $zeroSalesProductsCount من أصل $totalCatalogProducts منتج.
- Verified Sales by Category:
${categoryUnitsSold.isEmpty ? "لا توجد مبيعات لأي قسم حتى الآن." : jsonEncode(categoryUnitsSold)}

=== CRITICAL INVENTORY RADAR SAMPLES (WITH SALES TRUTH) ===
${jsonEncode(criticalProducts)}

=== ACTIVE CATEGORIES IN STORE ===
$categoriesSummary

CRITICAL ANTI-HALLUCINATION & FACT-CHECKING INSTRUCTIONS (STRICT COMPLIANCE REQUIRED):
1. ABSOLUTE PROHIBITION ON FABRICATING DEMAND:
   - YOU MUST NEVER state, imply, or assume that a product or category has "high demand" ("ارتفاع الطلب"), "popularity" ("إقبال كبير"), or is "fast selling" ("سريع البيع"), UNLESS its "units_sold" in the data above is strictly GREATER THAN ZERO (> 0)!
   - If a product has "units_sold": 0 or "has_been_ordered_by_customers": false, it means NOT A SINGLE CUSTOMER HAS EVER PURCHASED IT!
   - You are STRICTLY FORBIDDEN from stating or assuming that its low stock is due to sales, popularity, or customer demand.
   - For items with 0 sales, the low stock is purely due to low initial stock quantity or unstocked inventory. State this fact truthfully.
2. RESTOCKING RECOMMENDATION LOGIC:
   - For products with units_sold == 0:
     * NEVER recommend urgent bulk replenishment ("لا توصِ بطلب توريد عاجل بكميات كبيرة").
     * Instead, recommend evaluating customer interest, reviewing product pricing, marketing, or waiting for actual customer orders before tying up capital in inventory.
   - For products with units_sold > 0:
     * Recommend restocking proportional to actual verified sales velocity.
3. GROUNDED SUMMARY & INSIGHTS:
   - Base all claims and numbers strictly on the facts provided above.
   - If pending orders are high (${stats.pendingOrders} pending), emphasize confirming and shipping them to prevent churn.
   - If cancellations exist (${stats.cancelledOrders} cancelled), recommend investigating the causes.
   - Never invent imaginary market trends or sales for categories that have 0 sales.

Return ONLY a valid JSON object matching this exact schema:
{
  "summary": "ملخص تنفيذي عربي احترافي ومباشر يوضح حالة المبيعات والعمليات اليوم بدقة وصدق...",
  "sentiment": "positive | neutral | needs_attention",
  "key_insights": [
    "مؤشر مبني على الأرقام الحقيقية فقط...",
    "مؤشر آخر واقعي..."
  ],
  "recommendations": [
    "توصية تشغيلية قابلة للتنفيذ...",
    "توصية واقعية أخرى..."
  ],
  "stock_alerts": [
    {
      "product_id": "PROD-...",
      "product_name": "اسم المنتج",
      "current_stock": 2,
      "units_sold": 0,
      "risk_level": "critical",
      "suggested_action": "توصية واقعية خالية من ادعاء وجود طلب إذا كانت المبيعات 0",
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

    final briefingModel = AiExecutiveBriefingModel.fromJson(
      decoded,
      modelUsed: model,
      generatedAt: DateTime.now(),
    );

    // 6. Post-processing & hallucination protection:
    // Ensure that for any alert with 0 sales, suggestedAction does NOT claim high demand or urge bulk buying
    final sanitizedAlerts = briefingModel.stockAlerts.map((alert) {
      final realUnitsSold = productUnitsSold[alert.productId] ??
          productUnitsSold['name:${alert.productName.trim().toLowerCase()}'] ??
          alert.unitsSold;

      var action = alert.suggestedAction;
      if (realUnitsSold == 0) {
        final hallucinatedDemand = action.contains('ارتفاع الطلب') ||
            action.contains('إقبال') ||
            action.contains('طلب متزايد') ||
            action.contains('الطلب على') ||
            action.contains('شعبية') ||
            action.contains('سريع البيع') ||
            action.contains('طلب عاجل لـ') ||
            action.contains('طلب توريد عاجل');

        if (hallucinatedDemand) {
          action = alert.currentStock <= 0
              ? 'المنتج نفد تماماً بالمخزون ولم يسجل أي مبيعات سابقة. يوصى بدراسة اهتمام العملاء قبل طلب شحنة جديدة.'
              : 'المخزون منخفض (المتبقي: ${alert.currentStock}) مع عدم وجود طلبات سابقة من أي عميل. يوصى بمراجعة التسعير والتسويق قبل زيادة المخزون.';
        }
      }

      return alert.copyWith(
        unitsSold: realUnitsSold,
        suggestedAction: action,
      );
    }).toList();

    // Sanitize key insights if any insight claims high demand on unsold categories or products
    final sanitizedInsights = briefingModel.keyInsights.map((insight) {
      if (soldProductsList.isEmpty) {
        if (insight.contains('الطلب على منتجات') ||
            insight.contains('الاستفادة من الطلب') ||
            insight.contains('ارتفاع الطلب')) {
          return 'عدم وجود مبيعات سابقة يتطلب تركيز الجهود على تسويق المنتجات والتحقق من الأسعار قبل إعادة التوريد.';
        }
      }
      return insight;
    }).toList();

    // Sanitize recommendations
    final sanitizedRecommendations =
        briefingModel.actionableRecommendations.map((rec) {
      for (final p in stats.products) {
        final sold = productUnitsSold[p.id] ?? 0;
        if (sold == 0 &&
            (rec.contains(p.displayName) ||
                (p.nameEn.isNotEmpty && rec.contains(p.nameEn)))) {
          if (rec.contains('أوامر شراء فورية') ||
              rec.contains('طلب توريد عاجل') ||
              rec.contains('لتجنب نفاد')) {
            return 'مراجعة أسباب عدم طلب ${p.displayName} قبل إصدار أوامر شراء جديدة له.';
          }
        }
      }
      return rec;
    }).toList();

    return briefingModel.copyWith(
      stockAlerts: sanitizedAlerts,
      keyInsights: sanitizedInsights,
      actionableRecommendations: sanitizedRecommendations,
    );
  }
}

