import '../../domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Map<String, dynamic>> getUsersStats();
  Future<List<UserEntity>> getUsers();
}
