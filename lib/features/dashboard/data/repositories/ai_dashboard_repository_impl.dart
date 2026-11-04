import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/ai_executive_briefing_entity.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/ai_dashboard_repository.dart';
import '../datasources/ai_dashboard_local_datasource.dart';
import '../datasources/gemini_dashboard_remote_datasource.dart';

class AiDashboardRepositoryImpl implements AiDashboardRepository {
  final GeminiDashboardRemoteDataSource _remoteDataSource;
  final AiDashboardLocalDataSource _localDataSource;

  const AiDashboardRepositoryImpl({
    required GeminiDashboardRemoteDataSource remoteDataSource,
    required AiDashboardLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, AiExecutiveBriefingEntity>> generateBriefing({
    required DashboardStatsEntity stats,
    bool forceRefresh = false,
  }) async {
    // 1. Check local cache if not forced
    if (!forceRefresh) {
      try {
        final cached = await _localDataSource.getCachedBriefing();
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (_) {}
    }

    // 2. Fetch fresh analysis from Gemini
    try {
      final model = await _remoteDataSource.generateBriefing(stats);
      await _localDataSource.cacheBriefing(model);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response != null) {
        final code = e.response?.statusCode;
        final data = e.response?.data;
        String msg = 'خطأ أثناء تحليل لوحة التحكم بـ Gemini ($code)';
        if (data is Map && data['error'] is Map) {
          msg = data['error']['message'] ?? msg;
        }
        return Left(ServerFailure(message: msg, statusCode: code));
      }
      return Left(
        NetworkFailure(
          message: 'تعذر الاتصال بخدمة الذكاء الاصطناعي: ${e.message}',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<Either<Failure, AiExecutiveBriefingEntity?>> getCachedBriefing() async {
    try {
      final cached = await _localDataSource.getCachedBriefing();
      return Right(cached?.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في قراءة التقرير من الذاكرة المحلية: $e'),
      );
    }
  }
}

