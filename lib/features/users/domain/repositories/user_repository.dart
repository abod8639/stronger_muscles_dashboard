import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../entities/users_stats_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UsersStatsEntity>> getUsersStats({
    bool forceRefresh = false,
  });

  Future<Either<Failure, List<UserEntity>>> getUsers({
    bool forceRefresh = false,
  });
}
