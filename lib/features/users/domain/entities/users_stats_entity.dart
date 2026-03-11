import 'user_entity.dart';

class UsersStatsEntity {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final List<UserEntity> users;

  const UsersStatsEntity({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.users,
  });
}
