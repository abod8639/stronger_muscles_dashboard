import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/ai_executive_briefing_entity.dart';
import 'dashboard_providers.dart';

class AiExecutiveBriefingNotifier
    extends AsyncNotifier<AiExecutiveBriefingEntity?> {
  @override
  Future<AiExecutiveBriefingEntity?> build() async {
    // 1. Try to load cached briefing first
    final useCase = ref.watch(getAiExecutiveBriefingUseCaseProvider);
    final cachedResult = await useCase.getCached();

    AiExecutiveBriefingEntity? cachedEntity;
    cachedResult.fold(
      (_) => null,
      (data) => cachedEntity = data,
    );

    return cachedEntity;
  }

  /// Generates or refreshes the executive briefing and stock radar using Gemini AI
  Future<void> refreshBriefing({bool force = true}) async {
    final stats = ref.read(dashboardStatsNotifierProvider).value;
    if (stats == null) {
      AppFeedback.showWarning('يرجى انتظار اكتمال تحميل بيانات لوحة التحكم أولاً');
      return;
    }

    state = const AsyncValue.loading();

    final useCase = ref.read(getAiExecutiveBriefingUseCaseProvider);
    final result = await useCase(stats: stats, forceRefresh: force);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.toMessage(), StackTrace.current);
        AppFeedback.showError(failure.toMessage());
      },
      (briefing) {
        state = AsyncValue.data(briefing);
        AppFeedback.showSuccess('تم تحديث التقرير التنفيذي ورادار المخزون بنجاح');
      },
    );
  }
}
