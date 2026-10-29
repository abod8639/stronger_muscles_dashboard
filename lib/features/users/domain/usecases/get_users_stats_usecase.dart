import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/users_stats_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersStatsUseCase {
  final UserRepository _repository;

  const GetUsersStatsUseCase(this._repository);

  Future<Either<Failure, UsersStatsEntity>> call({
    bool forceRefresh = false,
  }) async {
    return _repository.getUsersStats(forceRefresh: forceRefresh);
  }
}
