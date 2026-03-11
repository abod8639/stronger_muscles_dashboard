// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersStatsModelImpl _$$UsersStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UsersStatsModelImpl(
      totalUsers: (json['total_users'] as num).toInt(),
      activeUsers: (json['active_users'] as num).toInt(),
      inactiveUsers: (json['inactive_users'] as num).toInt(),
      users: (json['users'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UsersStatsModelImplToJson(
        _$UsersStatsModelImpl instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'active_users': instance.activeUsers,
      'inactive_users': instance.inactiveUsers,
      'users': instance.users,
    };
