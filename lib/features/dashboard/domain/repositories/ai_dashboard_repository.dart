import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/ai_executive_briefing_entity.dart';
import '../entities/dashboard_stats_entity.dart';

/// Contract for generating and caching AI executive business briefings and stock radar.
abstract class AiDashboardRepository {
  Future<Either<Failure, AiExecutiveBriefingEntity>> generateBriefing({
    required DashboardStatsEntity stats,
    bool forceRefresh = false,
  });

  Future<Either<Failure, AiExecutiveBriefingEntity?>> getCachedBriefing();
}

