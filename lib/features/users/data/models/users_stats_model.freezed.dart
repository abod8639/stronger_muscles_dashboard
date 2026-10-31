// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UsersStatsModel _$UsersStatsModelFromJson(Map<String, dynamic> json) {
  return _UsersStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UsersStatsModel {
  @JsonKey(name: 'total_users')
  int get totalUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_users')
  int get activeUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'inactive_users')
  int get inactiveUsers => throw _privateConstructorUsedError;
  List<UserModel> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsersStatsModelCopyWith<UsersStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersStatsModelCopyWith<$Res> {
  factory $UsersStatsModelCopyWith(
          UsersStatsModel value, $Res Function(UsersStatsModel) then) =
      _$UsersStatsModelCopyWithImpl<$Res, UsersStatsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'inactive_users') int inactiveUsers,
      List<UserModel> users});
}

/// @nodoc
class _$UsersStatsModelCopyWithImpl<$Res, $Val extends UsersStatsModel>
    implements $UsersStatsModelCopyWith<$Res> {
  _$UsersStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? inactiveUsers = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveUsers: null == inactiveUsers
          ? _value.inactiveUsers
          : inactiveUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsersStatsModelImplCopyWith<$Res>
    implements $UsersStatsModelCopyWith<$Res> {
  factory _$$UsersStatsModelImplCopyWith(_$UsersStatsModelImpl value,
          $Res Function(_$UsersStatsModelImpl) then) =
      __$$UsersStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers,
      @JsonKey(name: 'active_users') int activeUsers,
      @JsonKey(name: 'inactive_users') int inactiveUsers,
      List<UserModel> users});
}

/// @nodoc
class __$$UsersStatsModelImplCopyWithImpl<$Res>
    extends _$UsersStatsModelCopyWithImpl<$Res, _$UsersStatsModelImpl>
    implements _$$UsersStatsModelImplCopyWith<$Res> {
  __$$UsersStatsModelImplCopyWithImpl(
      _$UsersStatsModelImpl _value, $Res Function(_$UsersStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? inactiveUsers = null,
    Object? users = null,
  }) {
    return _then(_$UsersStatsModelImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveUsers: null == inactiveUsers
          ? _value.inactiveUsers
          : inactiveUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersStatsModelImpl extends _UsersStatsModel {
  const _$UsersStatsModelImpl(
      {@JsonKey(name: 'total_users') required this.totalUsers,
      @JsonKey(name: 'active_users') required this.activeUsers,
      @JsonKey(name: 'inactive_users') required this.inactiveUsers,
      required final List<UserModel> users})
      : _users = users,
        super._();

  factory _$UsersStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersStatsModelImplFromJson(json);

  @override
  @JsonKey(name: 'total_users')
  final int totalUsers;
  @override
  @JsonKey(name: 'active_users')
  final int activeUsers;
  @override
  @JsonKey(name: 'inactive_users')
  final int inactiveUsers;
  final List<UserModel> _users;
  @override
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'UsersStatsModel(totalUsers: $totalUsers, activeUsers: $activeUsers, inactiveUsers: $inactiveUsers, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersStatsModelImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.inactiveUsers, inactiveUsers) ||
                other.inactiveUsers == inactiveUsers) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalUsers, activeUsers,
      inactiveUsers, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersStatsModelImplCopyWith<_$UsersStatsModelImpl> get copyWith =>
      __$$UsersStatsModelImplCopyWithImpl<_$UsersStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersStatsModelImplToJson(
      this,
    );
  }
}

abstract class _UsersStatsModel extends UsersStatsModel {
  const factory _UsersStatsModel(
      {@JsonKey(name: 'total_users') required final int totalUsers,
      @JsonKey(name: 'active_users') required final int activeUsers,
      @JsonKey(name: 'inactive_users') required final int inactiveUsers,
      required final List<UserModel> users}) = _$UsersStatsModelImpl;
  const _UsersStatsModel._() : super._();

  factory _UsersStatsModel.fromJson(Map<String, dynamic> json) =
      _$UsersStatsModelImpl.fromJson;

  @override
  @JsonKey(name: 'total_users')
  int get totalUsers;
  @override
  @JsonKey(name: 'active_users')
  int get activeUsers;
  @override
  @JsonKey(name: 'inactive_users')
  int get inactiveUsers;
  @override
  List<UserModel> get users;
  @override
  @JsonKey(ignore: true)
  _$$UsersStatsModelImplCopyWith<_$UsersStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
