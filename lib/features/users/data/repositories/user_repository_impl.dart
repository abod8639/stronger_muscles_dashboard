import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UsersStatsEntity>> getUsersStats({CancelToken? cancelToken}) async {
    try {
      final model = await remoteDataSource.getUsersStats(cancelToken: cancelToken);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({CancelToken? cancelToken}) async {
    try {
      final models = await remoteDataSource.getUsers(cancelToken: cancelToken);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e, stackTrace) {
      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }
}
