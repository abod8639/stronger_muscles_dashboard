import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/users_stats_entity.dart';
import 'user_model.dart';

part 'users_stats_model.freezed.dart';
part 'users_stats_model.g.dart';

@freezed
class UsersStatsModel with _$UsersStatsModel {
  const UsersStatsModel._();

  const factory UsersStatsModel({
    @JsonKey(name: 'total_users') required int totalUsers,
    @JsonKey(name: 'active_users') required int activeUsers,
    @JsonKey(name: 'inactive_users') required int inactiveUsers,
    required List<UserModel> users,
  }) = _UsersStatsModel;

  factory UsersStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UsersStatsModelFromJson(_mapStatsJson(json));

  UsersStatsEntity toEntity() => UsersStatsEntity(
        totalUsers: totalUsers,
        activeUsers: activeUsers,
        inactiveUsers: inactiveUsers,
        users: users.map((e) => e.toEntity()).toList(),
      );
}

Map<String, dynamic> _mapStatsJson(Map<String, dynamic> json) {
  return {
    'total_users': json['total_users'] ?? json['totalUsers'] ?? 0,
    'active_users': json['active_users'] ?? json['activeUsers'] ?? 0,
    'inactive_users': json['inactive_users'] ?? json['inactiveUsers'] ?? 0,
    'users': json['users'] ?? [],
  };
}
