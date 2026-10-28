import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Pure Dart UseCase for retrieving consolidated Dashboard statistics.
class GetDashboardDataUseCase {
  final DashboardRepository _repository;

  const GetDashboardDataUseCase(this._repository);

  Future<Either<Failure, DashboardStatsEntity>> call({
    bool forceRefresh = false,
  }) {
    return _repository.getDashboardStats(forceRefresh: forceRefresh);
  }
}
