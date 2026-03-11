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
    // In case the service returns the full response instead of just data
    final statsData = (data.containsKey('data')) ? data['data'] : data;
    return UsersStatsModel.fromJson(statsData as Map<String, dynamic>);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final data = await _userService.fetchUsers();
    // Consistently handle dynamic list or map-wrapped list
    if (data is Map && data.containsKey('data')) {
      final innerData = data['data'];
      if (innerData is List) return innerData.map((e) => UserModel.fromJson(e)).toList();
    }
    if (data is List) {
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }
}
