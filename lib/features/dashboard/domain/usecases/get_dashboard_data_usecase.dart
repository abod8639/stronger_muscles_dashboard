import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<DashboardStatsEntity> call() async {
    return await repository.getDashboardStats();
  }
}
