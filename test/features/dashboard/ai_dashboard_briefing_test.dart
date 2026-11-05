import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/config/gemini_config.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/ai_dashboard_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/gemini_dashboard_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/models/ai_copilot_answer_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/models/ai_executive_briefing_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/ai_dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/ai_executive_briefing_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/ai_dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/ask_ai_executive_copilot_usecase.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_ai_executive_briefing_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';

class MockGeminiDashboardRemoteDataSource
    implements GeminiDashboardRemoteDataSource {
  int callCount = 0;
  String? lastFocus;
  AiExecutiveBriefingModel? nextModel;

  @override
  Future<AiExecutiveBriefingModel> generateBriefing(
    DashboardStatsEntity stats, {
    String focus = 'comprehensive',
  }) async {
    callCount++;
    lastFocus = focus;
    return nextModel ??
        AiExecutiveBriefingModel(
          summary: 'أداء مبيعات ممتاز لليوم مدفوعاً بطلبات البروتين.',
          sentiment: 'positive',
          reportFocus: focus,
          keyInsights: const [
            'نمو إجمالي الإيرادات بنسبة 18%',
            'استقرار معدل إلغاء الطلبات عند 1%',
          ],
          actionableRecommendations: const [
            'تأكيد وشحن 4 طلبات معلقة لتفادي التأخير',
            'طلب توريد كرياتين لتفادي نفاد المخزون',
          ],
          stockAlerts: const [
            StockRadarAlertModel(
              productId: 'PROD-101',
              productName: 'جولد ستاندرد 2.27kg',
              currentStock: 2,
              riskLevel: 'critical',
              suggestedAction: 'طلب توريد 30 عبوة بشكل عاجل',
              categoryName: 'بروتينات',
            ),
          ],
          generatedAt: DateTime.now(),
          modelUsed: 'gemini-3.5-flash',
        );
  }

  @override
  Future<AiCopilotAnswerModel> askBriefingQuestion({
    required AiExecutiveBriefingEntity briefing,
    required DashboardStatsEntity stats,
    required String question,
  }) async {
    return AiCopilotAnswerModel(
      directAnswer: 'إجابة تجريبية للسؤال: $question',
      sections: const [
        AiCopilotSectionModel(
          title: 'مؤشرات الأداء',
          icon: 'analytics',
          points: ['نقطة تجريبية 1', 'نقطة تجريبية 2'],
        ),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AiExecutiveBriefingModel & StockRadarAlertModel Tests', () {
    test('roundtrip serialization between entity, model, and json preserves data', () {
      final now = DateTime(2026, 11, 4, 11, 0);
      final entity = AiExecutiveBriefingEntity(
        summary: 'استقرار في مبيعات المكملات مع تحذير مخزون.',
        sentiment: 'needs_attention',
        keyInsights: const ['زيادة في الطلبات المعلقة'],
        actionableRecommendations: const ['مراجعة شركة الشحن'],
        stockAlerts: const [
          StockRadarAlertEntity(
            productId: 'P-1',
            productName: 'واي بروتين',
            currentStock: 0,
            unitsSold: 15,
            riskLevel: 'out_of_stock',
            suggestedAction: 'شحنة فورية',
            categoryName: 'بروتين',
          ),
        ],
        generatedAt: now,
        modelUsed: 'gemini-3.5-flash',
      );

      final model = AiExecutiveBriefingModel.fromEntity(entity);
      final json = model.toJson();
      final fromJsonModel = AiExecutiveBriefingModel.fromJson(json);
      final restored = fromJsonModel.toEntity();

      expect(restored.summary, 'استقرار في مبيعات المكملات مع تحذير مخزون.');
      expect(restored.sentiment, 'needs_attention');
      expect(restored.keyInsights, contains('زيادة في الطلبات المعلقة'));
      expect(restored.actionableRecommendations, contains('مراجعة شركة الشحن'));
      expect(restored.stockAlerts.length, 1);
      expect(restored.stockAlerts.first.isOutOfStock, isTrue);
      expect(restored.stockAlerts.first.unitsSold, 15);
      expect(restored.stockAlerts.first.hasActualSales, isTrue);
      expect(restored.criticalAlertsCount, 1);
      expect(restored.modelUsed, 'gemini-3.5-flash');
    });

    test('StockRadarAlertEntity hasActualSales is false when unitsSold is 0', () {
      const alert = StockRadarAlertEntity(
        productId: 'P-2',
        productName: 'حزمة بناء العضلات أنيمال',
        currentStock: 5,
        unitsSold: 0,
        riskLevel: 'critical',
        suggestedAction: 'مراجعة التسعير',
      );
      expect(alert.hasActualSales, isFalse);
      expect(alert.isCritical, isTrue);
      expect(alert.unitsSold, 0);
    });
  });

  group('AiDashboardLocalDataSource Tests', () {
    late AiDashboardLocalDataSource localDataSource;

    setUp(() async {
      await GetStorage.init();
      localDataSource = AiDashboardLocalDataSourceImpl();
      await localDataSource.clearCache();
    });

    test('cacheBriefing, getCachedBriefing within maxAge, and clearCache', () async {
      final model = AiExecutiveBriefingModel(
        summary: 'ملخص كاش',
        sentiment: 'positive',
        keyInsights: const ['مؤشر 1'],
        actionableRecommendations: const ['توصية 1'],
        stockAlerts: const [],
        generatedAt: DateTime.now(),
        modelUsed: 'gemini-3.5-flash',
      );

      await localDataSource.cacheBriefing(model);

      final cached = await localDataSource.getCachedBriefing();
      expect(cached, isNotNull);
      expect(cached!.summary, 'ملخص كاش');
      expect(cached.sentiment, 'positive');

      // Clear cache
      await localDataSource.clearCache();
      final afterClear = await localDataSource.getCachedBriefing();
      expect(afterClear, isNull);
    });

    test('getCachedBriefing returns null if cache has expired', () async {
      final expiredModel = AiExecutiveBriefingModel(
        summary: 'ملخص قديم',
        sentiment: 'neutral',
        keyInsights: const [],
        actionableRecommendations: const [],
        stockAlerts: const [],
        generatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        modelUsed: 'gemini-3.5-flash',
      );

      await localDataSource.cacheBriefing(expiredModel);

      // maxAge is 2 hours -> should expire
      final cached = await localDataSource.getCachedBriefing(
        maxAge: const Duration(hours: 2),
      );
      expect(cached, isNull);
    });

    test('isolates cache between different focus modes', () async {
      final compModel = AiExecutiveBriefingModel(
        summary: 'ملخص شامل',
        sentiment: 'positive',
        reportFocus: 'comprehensive',
        keyInsights: const [],
        actionableRecommendations: const [],
        stockAlerts: const [],
        generatedAt: DateTime.now(),
        modelUsed: 'gemini-3.5-flash',
      );

      final invModel = AiExecutiveBriefingModel(
        summary: 'ملخص المخزون',
        sentiment: 'needs_attention',
        reportFocus: 'inventory',
        keyInsights: const [],
        actionableRecommendations: const [],
        stockAlerts: const [],
        generatedAt: DateTime.now(),
        modelUsed: 'gemini-3.5-flash',
      );

      await localDataSource.cacheBriefing(compModel, focus: 'comprehensive');
      await localDataSource.cacheBriefing(invModel, focus: 'inventory');

      final cachedComp =
          await localDataSource.getCachedBriefing(focus: 'comprehensive');
      final cachedInv =
          await localDataSource.getCachedBriefing(focus: 'inventory');

      expect(cachedComp?.summary, 'ملخص شامل');
      expect(cachedInv?.summary, 'ملخص المخزون');
    });
  });

  group('AiDashboardRepositoryImpl & UseCase Tests', () {
    late MockGeminiDashboardRemoteDataSource mockRemote;
    late AiDashboardLocalDataSource localDataSource;
    late AiDashboardRepository repository;
    late GetAiExecutiveBriefingUseCase useCase;

    setUp(() async {
      await GetStorage.init();
      localDataSource = AiDashboardLocalDataSourceImpl();
      await localDataSource.clearCache();
      mockRemote = MockGeminiDashboardRemoteDataSource();
      repository = AiDashboardRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: localDataSource,
      );
      useCase = GetAiExecutiveBriefingUseCase(repository);
    });

    test('generateBriefing fetches from remote on first call, caches, and returns cached on second call without forceRefresh', () async {
      const stats = DashboardStatsEntity.initial();

      // First call -> calls remote
      final result1 = await useCase(stats: stats, forceRefresh: false);
      expect(result1.isRight(), isTrue);
      expect(mockRemote.callCount, 1);
      result1.fold(
        (f) => fail('Should succeed'),
        (briefing) {
          expect(briefing.summary, contains('أداء مبيعات ممتاز'));
          expect(briefing.sentiment, 'positive');
          expect(briefing.stockAlerts.length, 1);
        },
      );

      // Second call without forceRefresh -> served from local cache!
      final result2 = await useCase(stats: stats, forceRefresh: false);
      expect(result2.isRight(), isTrue);
      expect(mockRemote.callCount, 1); // Not called again!

      // Third call with forceRefresh = true -> calls remote again
      final result3 = await useCase(stats: stats, forceRefresh: true);
      expect(result3.isRight(), isTrue);
      expect(mockRemote.callCount, 2); // Called again!
    });

    test('generateBriefing passes focus mode to remote and repository', () async {
      const stats = DashboardStatsEntity.initial();
      final result = await useCase(stats: stats, focus: 'inventory', forceRefresh: true);
      expect(result.isRight(), isTrue);
      expect(mockRemote.lastFocus, 'inventory');
    });

    test('AskAiExecutiveCopilotUseCase returns answer from repository', () async {
      final copilotUseCase = AskAiExecutiveCopilotUseCase(repository);
      const stats = DashboardStatsEntity.initial();
      final briefing = AiExecutiveBriefingEntity(
        summary: 'ملخص',
        sentiment: 'positive',
        reportFocus: 'comprehensive',
        keyInsights: const [],
        actionableRecommendations: const [],
        stockAlerts: const [],
        generatedAt: DateTime.now(),
        modelUsed: 'gemini-3.5-flash',
      );

      final result = await copilotUseCase(
        briefing: briefing,
        stats: stats,
        question: 'كيف نسرع الطلبات؟',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (f) => fail('Should succeed'),
        (answer) {
          expect(
            answer.directAnswer,
            contains('إجابة تجريبية للسؤال: كيف نسرع الطلبات؟'),
          );
          expect(answer.sections.length, 1);
          expect(answer.sections.first.points.length, 2);
          expect(answer.sections.first.title, 'مؤشرات الأداء');
          expect(answer.toPlainText(), contains('■ مؤشرات الأداء:'));
        },
      );
    });

    test('AiCopilotAnswerModel.fromRawText cleans raw asterisks, headers, and greetings', () {
      const rawText = '''
أهلاً بك، بصفتي مساعدك التنفيذي الذكي لمتجر Stronger Muscles
### 📊 نسب توزيع ومؤشرات المبيعات والطلبات الحالية:
* **52.6%** من إجمالي الطلبات (10 طلبات معلقة)**
* **15.7%** نسبة الطلبات الملغاة**
---
### 🚀 خطوات عملية مقترحة للمعالجة:
1. **تسريع معالجة الطلبات المعلقة فوراً**
2. **مراجعة المنتجات الراكدة**
''';

      final model = AiCopilotAnswerModel.fromRawText(rawText);
      final entity = model.toEntity();

      // Ensure no raw asterisks or headers remain in the direct answer or points
      expect(entity.directAnswer.contains('*'), isFalse);
      expect(entity.directAnswer.contains('###'), isFalse);
      expect(entity.sections.length, greaterThanOrEqualTo(2));

      for (final sec in entity.sections) {
        expect(sec.title.contains('*'), isFalse);
        expect(sec.title.contains('#'), isFalse);
        for (final pt in sec.points) {
          expect(pt.contains('**'), isFalse);
          expect(pt.contains('*'), isFalse);
        }
      }

      // Check toPlainText has clean formatting without markdown asterisks
      final plain = entity.toPlainText();
      expect(plain.contains('**'), isFalse);
      expect(plain.contains('###'), isFalse);
    });
  });

  group('GeminiDashboardRemoteDataSourceImpl Anti-Hallucination Guardrails Tests', () {
    late Dio dio;

    setUp(() async {
      await GetStorage.init();
      await GeminiConfig.saveApiKey('test-api-key-12345');
      dio = Dio();
    });

    test('sanitizes hallucinated demand for zero-sales products and preserves real sales metrics', () async {
      // 1. Prepare products:
      // Product A: 5 in stock, NEVER ordered (0 sales)
      final productA = ProductEntity(
        id: 'prod-a',
        nameAr: 'حزمة بناء العضلات أنيمال',
        nameEn: 'Animal Muscle Gain Stack',
        descriptionAr: 'وصف',
        descriptionEn: 'desc',
        price: 50000,
        stockQuantity: 5,
        categoryId: 'cat-mass',
        imageUrls: const [],
        isActive: true,
        isFeatured: false,
      );

      // Product B: 2 in stock, 10 units sold across delivered orders
      final productB = ProductEntity(
        id: 'prod-b',
        nameAr: 'واي بروتين جولد',
        nameEn: 'Gold Standard Whey',
        descriptionAr: 'وصف',
        descriptionEn: 'desc',
        price: 80000,
        stockQuantity: 2,
        categoryId: 'cat-protein',
        imageUrls: const [],
        isActive: true,
        isFeatured: false,
      );

      final orderDelivered = OrderEntity(
        id: 'order-1',
        userId: 'user-1',
        userName: 'أحمد',
        userEmail: 'ahmed@example.com',
        totalAmount: 800000,
        subtotal: 800000,
        status: OrderStatus.delivered,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: 'cash',
        addressId: 'addr-1',
        orderDate: DateTime.now(),
        items: const [
          OrderItemEntity(
            id: 'item-1',
            productId: 'prod-b',
            productName: 'واي بروتين جولد',
            quantity: 10,
            unitPrice: 80000,
            subtotal: 800000,
          ),
        ],
      );

      final stats = DashboardStatsEntity(
        totalRevenue: 800000,
        totalOrders: 1,
        totalUsers: 1,
        totalProducts: 2,
        orders: [orderDelivered],
        products: [productA, productB],
        categories: const [],
        pendingOrders: 0,
        processingOrders: 0,
        shippedOrders: 0,
        deliveredOrders: 1,
        cancelledOrders: 0,
        inStock: 0,
        lowStock: 2,
        outOfStock: 0,
      );

      // 2. Setup mock response where LLM hallucinated demand on product A:
      final fakeGeminiJson = {
        'candidates': [
          {
            'content': {
              'parts': [
                {
                  'text': jsonEncode({
                    'summary': 'أداء مبيعات واعد مع وجود نقص في بعض الأصناف.',
                    'sentiment': 'needs_attention',
                    'key_insights': [
                      'مبيعات قوية لمنتج واي بروتين جولد',
                      'الاستفادة من الطلب على منتجات الضخامة وبناء العضلات',
                    ],
                    'recommendations': [
                      'إصدار أوامر شراء فورية لـ حزمة بناء العضلات أنيمال لتجنب نفاد المخزون',
                    ],
                    'stock_alerts': [
                      {
                        'product_id': 'prod-a',
                        'product_name': 'حزمة بناء العضلات أنيمال',
                        'current_stock': 5,
                        'risk_level': 'critical',
                        'suggested_action': 'طلب توريد عاجل لـ 40 وحدة إضافية نظراً لارتفاع الطلب على فئة Mass-Gainer',
                        'category_name': 'Mass-Gainer',
                      },
                      {
                        'product_id': 'prod-b',
                        'product_name': 'واي بروتين جولد',
                        'current_stock': 2,
                        'risk_level': 'critical',
                        'suggested_action': 'إعادة طلب 20 وحدة لتغطية المبيعات المستمرة',
                        'category_name': 'بروتينات',
                      },
                    ],
                  }),
                },
              ],
            },
          },
        ],
      };

      dio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        return ResponseBody.fromString(
          jsonEncode(fakeGeminiJson),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final remoteDataSource = GeminiDashboardRemoteDataSourceImpl(dio: dio);
      final briefing = await remoteDataSource.generateBriefing(stats);

      // Verify Product A (0 sales):
      final alertA = briefing.stockAlerts.firstWhere((a) => a.productId == 'prod-a');
      expect(alertA.unitsSold, 0);
      expect(alertA.hasActualSales, isFalse);
      // The hallucinated demand claim must be sanitized!
      expect(alertA.suggestedAction.contains('ارتفاع الطلب'), isFalse);
      expect(alertA.suggestedAction.contains('طلب توريد عاجل لـ 40 وحدة'), isFalse);
      expect(alertA.suggestedAction.contains('عدم وجود طلبات سابقة'), isTrue);

      // Verify Product B (10 sales):
      final alertB = briefing.stockAlerts.firstWhere((a) => a.productId == 'prod-b');
      expect(alertB.unitsSold, 10);
      expect(alertB.hasActualSales, isTrue);
      expect(alertB.suggestedAction, 'إعادة طلب 20 وحدة لتغطية المبيعات المستمرة');

      // Verify recommendation for Product A was sanitized
      final recForA = briefing.actionableRecommendations.firstWhere(
        (r) => r.contains('حزمة بناء العضلات أنيمال'),
      );
      expect(recForA.contains('أوامر شراء فورية'), isFalse);
      expect(recForA.contains('مراجعة أسباب عدم طلب'), isTrue);
    });
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;
  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<dynamic>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
