import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../datasources/settings_remote_datasource.dart';
import '../mappers/settings_mapper.dart';

/// Single Source of Truth (SSOT) implementation of [SettingsRepository].
/// Coordinates between [SettingsRemoteDataSource] (Dio) and [SettingsLocalDataSource] (Hive)
/// with offline resilience and functional error handling via [fpdart.Either].
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;
  final SettingsLocalDataSource _localDataSource;

  const SettingsRepositoryImpl({
    required SettingsRemoteDataSource remoteDataSource,
    required SettingsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final remoteModel = await _remoteDataSource.getSettings();
      await _localDataSource.cacheSettings(remoteModel);
      return Right(remoteModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint(
        '⚠️ [SettingsRepositoryImpl] Remote fetch failed, attempting local cache: $e',
      );
      try {
        final cachedModel = await _localDataSource.getCachedSettings();
        if (cachedModel != null) {
          debugPrint(
            '✅ [SettingsRepositoryImpl] Serving settings from Hive cache',
          );
          return Right(cachedModel.toEntity());
        }
      } catch (cacheError) {
        debugPrint(
          '⚠️ [SettingsRepositoryImpl] Local cache error: $cacheError',
        );
      }

      // If remote and cache both fail, fallback to resilient default configuration
      if (e.toString().contains('404')) {
        return const Right(SettingsEntity());
      }

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> updateSettings(
    SettingsEntity settings,
  ) async {
    try {
      final model = settings.toModel();
      final updatedModel = await _remoteDataSource.updateSettings(
        model.toJson(),
      );
      await _localDataSource.cacheSettings(updatedModel);
      return Right(updatedModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ [SettingsRepositoryImpl.updateSettings] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAppCache() async {
    try {
      await _localDataSource.clearCache();
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('❌ [SettingsRepositoryImpl.clearAppCache] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
