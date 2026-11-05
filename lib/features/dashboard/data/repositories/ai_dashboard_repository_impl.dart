import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/ai_copilot_answer_entity.dart';
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
    String focus = 'comprehensive',
    bool forceRefresh = false,
  }) async {
    // 1. Check local cache if not forced
    if (!forceRefresh) {
      try {
        final cached = await _localDataSource.getCachedBriefing(focus: focus);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (_) {}
    }

    // 2. Fetch fresh analysis from Gemini
    try {
      final model = await _remoteDataSource.generateBriefing(stats, focus: focus);
      await _localDataSource.cacheBriefing(model, focus: focus);
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
  Future<Either<Failure, AiExecutiveBriefingEntity?>> getCachedBriefing({
    String focus = 'comprehensive',
  }) async {
    try {
      final cached = await _localDataSource.getCachedBriefing(focus: focus);
      return Right(cached?.toEntity());
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل في قراءة التقرير من الذاكرة المحلية: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, AiCopilotAnswerEntity>> askBriefingQuestion({
    required AiExecutiveBriefingEntity briefing,
    required DashboardStatsEntity stats,
    required String question,
  }) async {
    try {
      final model = await _remoteDataSource.askBriefingQuestion(
        briefing: briefing,
        stats: stats,
        question: question,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response != null) {
        final code = e.response?.statusCode;
        final data = e.response?.data;
        String msg = 'خطأ من المساعد الذكي ($code)';
        if (data is Map && data['error'] is Map) {
          msg = data['error']['message'] ?? msg;
        }
        return Left(ServerFailure(message: msg, statusCode: code));
      }
      return Left(
        NetworkFailure(
          message: 'تعذر الاتصال بالمساعد الذكي: ${e.message}',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}

