import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/ai_dashboard_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/gemini_dashboard_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/models/ai_executive_briefing_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/ai_dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/ai_executive_briefing_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/ai_dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_ai_executive_briefing_usecase.dart';

class MockGeminiDashboardRemoteDataSource
    implements GeminiDashboardRemoteDataSource {
  int callCount = 0;
  AiExecutiveBriefingModel? nextModel;

  @override
  Future<AiExecutiveBriefingModel> generateBriefing(
    DashboardStatsEntity stats,
  ) async {
    callCount++;
    return nextModel ??
        AiExecutiveBriefingModel(
          summary: 'أداء مبيعات ممتاز لليوم مدفوعاً بطلبات البروتين.',
          sentiment: 'positive',
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
      expect(restored.criticalAlertsCount, 1);
      expect(restored.modelUsed, 'gemini-3.5-flash');
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
  });
}
