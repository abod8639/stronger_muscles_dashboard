import '../entities/users_stats_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersStatsUseCase {
  final UserRepository repository;

  GetUsersStatsUseCase(this.repository);

  Future<UsersStatsEntity> call() async {
    return await repository.getUsersStats();
  }
}
