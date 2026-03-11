import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UsersStatsEntity> getUsersStats() async {
    final model = await remoteDataSource.getUsersStats();
    return model.toEntity();
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    final models = await remoteDataSource.getUsers();
    return models.map((model) => model.toEntity()).toList();
  }
}
