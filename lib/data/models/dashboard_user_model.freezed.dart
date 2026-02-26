// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) {
  return _DashboardResponse.fromJson(json);
}

/// @nodoc
mixin _$DashboardResponse {
  int get totalUsers => throw _privateConstructorUsedError;
  List<DashboardUser> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardResponseCopyWith<DashboardResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardResponseCopyWith<$Res> {
  factory $DashboardResponseCopyWith(
    DashboardResponse value,
    $Res Function(DashboardResponse) then,
  ) = _$DashboardResponseCopyWithImpl<$Res, DashboardResponse>;
  @useResult
  $Res call({int totalUsers, List<DashboardUser> users});
}

/// @nodoc
class _$DashboardResponseCopyWithImpl<$Res, $Val extends DashboardResponse>
    implements $DashboardResponseCopyWith<$Res> {
  _$DashboardResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalUsers = null, Object? users = null}) {
    return _then(
      _value.copyWith(
            totalUsers: null == totalUsers
                ? _value.totalUsers
                : totalUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            users: null == users
                ? _value.users
                : users // ignore: cast_nullable_to_non_nullable
                      as List<DashboardUser>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardResponseImplCopyWith<$Res>
    implements $DashboardResponseCopyWith<$Res> {
  factory _$$DashboardResponseImplCopyWith(
    _$DashboardResponseImpl value,
    $Res Function(_$DashboardResponseImpl) then,
  ) = __$$DashboardResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalUsers, List<DashboardUser> users});
}

/// @nodoc
class __$$DashboardResponseImplCopyWithImpl<$Res>
    extends _$DashboardResponseCopyWithImpl<$Res, _$DashboardResponseImpl>
    implements _$$DashboardResponseImplCopyWith<$Res> {
  __$$DashboardResponseImplCopyWithImpl(
    _$DashboardResponseImpl _value,
    $Res Function(_$DashboardResponseImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalUsers = null, Object? users = null}) {
    return _then(
      _$DashboardResponseImpl(
        totalUsers: null == totalUsers
            ? _value.totalUsers
            : totalUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<DashboardUser>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardResponseImpl implements _DashboardResponse {
  const _$DashboardResponseImpl({
    required this.totalUsers,
    required final List<DashboardUser> users,
  }) : _users = users;

  factory _$DashboardResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardResponseImplFromJson(json);

  @override
  final int totalUsers;
  final List<DashboardUser> _users;
  @override
  List<DashboardUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'DashboardResponse(totalUsers: $totalUsers, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardResponseImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalUsers,
    const DeepCollectionEquality().hash(_users),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      __$$DashboardResponseImplCopyWithImpl<_$DashboardResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardResponseImplToJson(this);
  }
}

abstract class _DashboardResponse implements DashboardResponse {
  const factory _DashboardResponse({
    required final int totalUsers,
    required final List<DashboardUser> users,
  }) = _$DashboardResponseImpl;

  factory _DashboardResponse.fromJson(Map<String, dynamic> json) =
      _$DashboardResponseImpl.fromJson;

  @override
  int get totalUsers;
  @override
  List<DashboardUser> get users;
  @override
  @JsonKey(ignore: true)
  _$$DashboardResponseImplCopyWith<_$DashboardResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardUser _$DashboardUserFromJson(Map<String, dynamic> json) {
  return _DashboardUser.fromJson(json);
}

/// @nodoc
mixin _$DashboardUser {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(4)
  String get role => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(7)
  double get totalSpent => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @HiveField(10)
  List<UserAddress> get addresses => throw _privateConstructorUsedError;
  @HiveField(11)
  int get ordersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardUserCopyWith<DashboardUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardUserCopyWith<$Res> {
  factory $DashboardUserCopyWith(
    DashboardUser value,
    $Res Function(DashboardUser) then,
  ) = _$DashboardUserCopyWithImpl<$Res, DashboardUser>;
  @useResult
  $Res call({
    @HiveField(0) int id,
    @HiveField(1) String name,
    @HiveField(2) String? email,
    @HiveField(3) String? phone,
    @HiveField(4) String role,
    @HiveField(5) bool isActive,
    @HiveField(6) String? photoUrl,
    @HiveField(7) double totalSpent,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) DateTime? lastLogin,
    @HiveField(10) List<UserAddress> addresses,
    @HiveField(11) int ordersCount,
  });
}

/// @nodoc
class _$DashboardUserCopyWithImpl<$Res, $Val extends DashboardUser>
    implements $DashboardUserCopyWith<$Res> {
  _$DashboardUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? photoUrl = freezed,
    Object? totalSpent = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? addresses = null,
    Object? ordersCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            addresses: null == addresses
                ? _value.addresses
                : addresses // ignore: cast_nullable_to_non_nullable
                      as List<UserAddress>,
            ordersCount: null == ordersCount
                ? _value.ordersCount
                : ordersCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardUserImplCopyWith<$Res>
    implements $DashboardUserCopyWith<$Res> {
  factory _$$DashboardUserImplCopyWith(
    _$DashboardUserImpl value,
    $Res Function(_$DashboardUserImpl) then,
  ) = __$$DashboardUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) int id,
    @HiveField(1) String name,
    @HiveField(2) String? email,
    @HiveField(3) String? phone,
    @HiveField(4) String role,
    @HiveField(5) bool isActive,
    @HiveField(6) String? photoUrl,
    @HiveField(7) double totalSpent,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) DateTime? lastLogin,
    @HiveField(10) List<UserAddress> addresses,
    @HiveField(11) int ordersCount,
  });
}

/// @nodoc
class __$$DashboardUserImplCopyWithImpl<$Res>
    extends _$DashboardUserCopyWithImpl<$Res, _$DashboardUserImpl>
    implements _$$DashboardUserImplCopyWith<$Res> {
  __$$DashboardUserImplCopyWithImpl(
    _$DashboardUserImpl _value,
    $Res Function(_$DashboardUserImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? role = null,
    Object? isActive = null,
    Object? photoUrl = freezed,
    Object? totalSpent = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? addresses = null,
    Object? ordersCount = null,
  }) {
    return _then(
      _$DashboardUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        addresses: null == addresses
            ? _value._addresses
            : addresses // ignore: cast_nullable_to_non_nullable
                  as List<UserAddress>,
        ordersCount: null == ordersCount
            ? _value.ordersCount
            : ordersCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardUserImpl extends _DashboardUser {
  const _$DashboardUserImpl({
    @HiveField(0) required this.id,
    @HiveField(1) this.name = '',
    @HiveField(2) this.email,
    @HiveField(3) this.phone,
    @HiveField(4) this.role = 'customer',
    @HiveField(5) this.isActive = true,
    @HiveField(6) this.photoUrl,
    @HiveField(7) this.totalSpent = 0.0,
    @HiveField(8) this.createdAt,
    @HiveField(9) this.lastLogin,
    @HiveField(10) final List<UserAddress> addresses = const [],
    @HiveField(11) this.ordersCount = 0,
  }) : _addresses = addresses,
       super._();

  factory _$DashboardUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardUserImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @JsonKey()
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String? email;
  @override
  @HiveField(3)
  final String? phone;
  @override
  @JsonKey()
  @HiveField(4)
  final String role;
  @override
  @JsonKey()
  @HiveField(5)
  final bool isActive;
  @override
  @HiveField(6)
  final String? photoUrl;
  @override
  @JsonKey()
  @HiveField(7)
  final double totalSpent;
  @override
  @HiveField(8)
  final DateTime? createdAt;
  @override
  @HiveField(9)
  final DateTime? lastLogin;
  final List<UserAddress> _addresses;
  @override
  @JsonKey()
  @HiveField(10)
  List<UserAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  @JsonKey()
  @HiveField(11)
  final int ordersCount;

  @override
  String toString() {
    return 'DashboardUser(id: $id, name: $name, email: $email, phone: $phone, role: $role, isActive: $isActive, photoUrl: $photoUrl, totalSpent: $totalSpent, createdAt: $createdAt, lastLogin: $lastLogin, addresses: $addresses, ordersCount: $ordersCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            const DeepCollectionEquality().equals(
              other._addresses,
              _addresses,
            ) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    phone,
    role,
    isActive,
    photoUrl,
    totalSpent,
    createdAt,
    lastLogin,
    const DeepCollectionEquality().hash(_addresses),
    ordersCount,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardUserImplCopyWith<_$DashboardUserImpl> get copyWith =>
      __$$DashboardUserImplCopyWithImpl<_$DashboardUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardUserImplToJson(this);
  }
}

abstract class _DashboardUser extends DashboardUser {
  const factory _DashboardUser({
    @HiveField(0) required final int id,
    @HiveField(1) final String name,
    @HiveField(2) final String? email,
    @HiveField(3) final String? phone,
    @HiveField(4) final String role,
    @HiveField(5) final bool isActive,
    @HiveField(6) final String? photoUrl,
    @HiveField(7) final double totalSpent,
    @HiveField(8) final DateTime? createdAt,
    @HiveField(9) final DateTime? lastLogin,
    @HiveField(10) final List<UserAddress> addresses,
    @HiveField(11) final int ordersCount,
  }) = _$DashboardUserImpl;
  const _DashboardUser._() : super._();

  factory _DashboardUser.fromJson(Map<String, dynamic> json) =
      _$DashboardUserImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String? get email;
  @override
  @HiveField(3)
  String? get phone;
  @override
  @HiveField(4)
  String get role;
  @override
  @HiveField(5)
  bool get isActive;
  @override
  @HiveField(6)
  String? get photoUrl;
  @override
  @HiveField(7)
  double get totalSpent;
  @override
  @HiveField(8)
  DateTime? get createdAt;
  @override
  @HiveField(9)
  DateTime? get lastLogin;
  @override
  @HiveField(10)
  List<UserAddress> get addresses;
  @override
  @HiveField(11)
  int get ordersCount;
  @override
  @JsonKey(ignore: true)
  _$$DashboardUserImplCopyWith<_$DashboardUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
