import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase(this.repository);

  Future<Either<Failure, DashboardStatsEntity>> call({
    CancelToken? cancelToken,
  }) async {
    return await repository.getDashboardStats(cancelToken: cancelToken);
  }
}
