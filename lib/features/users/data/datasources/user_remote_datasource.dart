import '../../../../core/network/api/user_service.dart';
import '../models/user_model.dart';
import '../models/users_stats_model.dart';

abstract class UserRemoteDataSource {
  Future<UsersStatsModel> getUsersStats();
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserService _userService;

  UserRemoteDataSourceImpl(this._userService);

  @override
  Future<UsersStatsModel> getUsersStats() async {
    final data = await _userService.fetchUsersStats();
    return UsersStatsModel.fromJson(data);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final data = await _userService.fetchUsers();
    return data.map((e) => UserModel.fromJson(e)).toList();
  }
}
