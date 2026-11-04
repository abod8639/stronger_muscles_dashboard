import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/ai_executive_briefing_entity.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/ai_dashboard_repository.dart';

class GetAiExecutiveBriefingUseCase {
  final AiDashboardRepository _repository;

  const GetAiExecutiveBriefingUseCase(this._repository);

  Future<Either<Failure, AiExecutiveBriefingEntity>> call({
    required DashboardStatsEntity stats,
    bool forceRefresh = false,
  }) {
    return _repository.generateBriefing(
      stats: stats,
      forceRefresh: forceRefresh,
    );
  }

  Future<Either<Failure, AiExecutiveBriefingEntity?>> getCached() {
    return _repository.getCachedBriefing();
  }
}

