import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> getUsersStats() async {
    return await remoteDataSource.getUsersStats();
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    final models = await remoteDataSource.getUsers();
    return models.map((model) => model.toEntity()).toList();
  }
}
