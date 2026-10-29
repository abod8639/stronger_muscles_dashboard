import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UsersStatsEntity>> getUsersStats({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      try {
        final isValid = await _localDataSource.isStatsCacheValid();
        if (isValid) {
          final cached = await _localDataSource.getCachedUsersStats();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        }
      } catch (_) {
        // Fallback to remote if cache read fails
      }
    }

    try {
      final model = await _remoteDataSource.getUsersStats();
      await _localDataSource.cacheUsersStats(model);
      await _localDataSource.cacheUsers(model.users);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      // Fallback to cache on remote failure
      try {
        final cached = await _localDataSource.getCachedUsersStats();
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (_) {}

      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      try {
        final cached = await _localDataSource.getCachedUsers();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}
    }

    try {
      final models = await _remoteDataSource.getUsers();
      await _localDataSource.cacheUsers(models);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e, stackTrace) {
      try {
        final cached = await _localDataSource.getCachedUsers();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}

      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }
}
