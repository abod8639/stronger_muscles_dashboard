import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/dashboard_stats_entity.dart';

/// Pure Dart Repository Contract for the Dashboard feature.
/// Strictly decoupled from Flutter, Dio, Hive, and 3rd-party networking libraries.
abstract class DashboardRepository {
  /// Fetches consolidated dashboard statistics.
  /// If [forceRefresh] is true, bypasses the local cache.
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats({
    bool forceRefresh = false,
  });
}
