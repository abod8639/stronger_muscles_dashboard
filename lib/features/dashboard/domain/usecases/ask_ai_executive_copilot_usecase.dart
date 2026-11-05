import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/ai_copilot_answer_entity.dart';
import '../entities/ai_executive_briefing_entity.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/ai_dashboard_repository.dart';

class AskAiExecutiveCopilotUseCase {
  final AiDashboardRepository _repository;

  const AskAiExecutiveCopilotUseCase(this._repository);

  Future<Either<Failure, AiCopilotAnswerEntity>> call({
    required AiExecutiveBriefingEntity briefing,
    required DashboardStatsEntity stats,
    required String question,
  }) {
    return _repository.askBriefingQuestion(
      briefing: briefing,
      stats: stats,
      question: question,
    );
  }
}

