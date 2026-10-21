import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/dashboard_stats_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats({
    CancelToken? cancelToken,
  });
}
