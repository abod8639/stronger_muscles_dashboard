import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../entities/users_stats_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UsersStatsEntity>> getUsersStats({CancelToken? cancelToken});
  Future<Either<Failure, List<UserEntity>>> getUsers({CancelToken? cancelToken});
}
