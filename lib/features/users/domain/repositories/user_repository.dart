import '../entities/user_entity.dart';
import '../entities/users_stats_entity.dart';

abstract class UserRepository {
  Future<UsersStatsEntity> getUsersStats();
  Future<List<UserEntity>> getUsers();
}
