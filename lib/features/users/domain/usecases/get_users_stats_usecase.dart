import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/users_stats_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersStatsUseCase {
  final UserRepository repository;

  GetUsersStatsUseCase(this.repository);

  Future<Either<Failure, UsersStatsEntity>> call({CancelToken? cancelToken}) async {
    return await repository.getUsersStats(cancelToken: cancelToken);
  }
}
