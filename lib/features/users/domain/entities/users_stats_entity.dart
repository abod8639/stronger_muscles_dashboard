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

  UsersStatsEntity copyWith({
    int? totalUsers,
    int? activeUsers,
    int? inactiveUsers,
    List<UserEntity>? users,
  }) {
    return UsersStatsEntity(
      totalUsers: totalUsers ?? this.totalUsers,
      activeUsers: activeUsers ?? this.activeUsers,
      inactiveUsers: inactiveUsers ?? this.inactiveUsers,
      users: users ?? this.users,
    );
  }
}
