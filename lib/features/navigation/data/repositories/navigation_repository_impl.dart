import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/mappers/navigation_mapper.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/repositories/navigation_repository.dart';

/// Single Source of Truth for Navigation feature data.
/// Orchestrates calls between Remote data source (Dio) and Local data source (Hive cache).
/// 100% testable via Constructor Dependency Injection.
class NavigationRepositoryImpl implements NavigationRepository {
  final NavigationRemoteDataSource _remoteDataSource;
  final NavigationLocalDataSource _localDataSource;

  NavigationRepositoryImpl({
    required NavigationRemoteDataSource remoteDataSource,
    required NavigationLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, NavigationBadgesEntity>> getNavigationBadges({
    bool forceRefresh = false,
  }) async {
    // 1. Check local Hive cache if refresh is not forced
    if (!forceRefresh) {
      final isCacheValid = await _localDataSource.isCacheValid();
      if (isCacheValid) {
        try {
          final cached = await _localDataSource.getCachedBadges();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        } catch (_) {
          // Fall through to remote fetch on cache read error
        }
      }
    }

    // 2. Fetch fresh remote data from backend
    try {
      final remoteModel = await _remoteDataSource.getNavigationBadges();

      // 3. Update Hive cache
      await _localDataSource.cacheBadges(remoteModel);

      return Right(remoteModel.toEntity());
    } on AppException catch (e) {
      // 4. Resilient fallback to stale cache on network failure
      try {
        final fallback = await _localDataSource.getCachedBadges();
        if (fallback != null) {
          return Right(fallback.toEntity());
        }
      } catch (_) {}

      return Left(NetworkErrorHandler.handleException(e));
    } catch (e, stackTrace) {
      debugPrint('NavigationRepositoryImpl Exception: $e');
      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }
}
