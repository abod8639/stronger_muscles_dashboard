import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';
import '../datasources/theme_remote_datasource.dart';
import '../mappers/theme_mapper.dart';

/// Single Source of Truth (SSOT) implementation of [ThemeRepository].
/// Coordinates between [ThemeLocalDataSource] (Hive) and [ThemeRemoteDataSource] (Dio)
/// with functional error handling via [fpdart.Either].
class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _localDataSource;
  final ThemeRemoteDataSource _remoteDataSource;

  const ThemeRepositoryImpl({
    required ThemeLocalDataSource localDataSource,
    required ThemeRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ThemeEntity>> getTheme() async {
    try {
      final cachedModel = await _localDataSource.getCachedTheme();
      if (cachedModel != null) {
        return Right(cachedModel.toEntity());
      }

      // Check remote if local cache is empty
      final remoteModel = await _remoteDataSource.getRemoteTheme();
      if (remoteModel != null) {
        await _localDataSource.cacheTheme(remoteModel);
        return Right(remoteModel.toEntity());
      }

      // Default theme for the dashboard is dark mode
      const defaultEntity = ThemeEntity(mode: AppThemeMode.dark);
      await _localDataSource.cacheTheme(defaultEntity.toModel());
      return const Right(defaultEntity);
    } catch (e, stackTrace) {
      debugPrint('⚠️ [ThemeRepositoryImpl.getTheme] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ThemeEntity>> setTheme(AppThemeMode mode) async {
    try {
      final entity = ThemeEntity(mode: mode, updatedAt: DateTime.now());
      final model = entity.toModel();

      await _localDataSource.cacheTheme(model);
      await _remoteDataSource.updateRemoteTheme(model);

      return Right(entity);
    } catch (e, stackTrace) {
      debugPrint('❌ [ThemeRepositoryImpl.setTheme] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ThemeEntity>> toggleTheme() async {
    try {
      final currentRes = await getTheme();
      final currentEntity = currentRes.getOrElse((_) => const ThemeEntity(mode: AppThemeMode.dark));

      final newMode = currentEntity.mode == AppThemeMode.dark
          ? AppThemeMode.light
          : AppThemeMode.dark;

      return await setTheme(newMode);
    } catch (e, stackTrace) {
      debugPrint('❌ [ThemeRepositoryImpl.toggleTheme] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
