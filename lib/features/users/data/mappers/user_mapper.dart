import '../../domain/entities/user_address_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../models/user_address.dart';
import '../models/user_model.dart';
import '../models/users_stats_model.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      role: role ?? 'user',
      isActive: isActive,
      createdAt: createdAt,
      lastLogin: lastLogin,
      totalSpent: totalSpent,
      ordersCount: ordersCount,
      addresses: addresses.map((a) => a.toEntity()).toList(),
    );
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      lastLogin: lastLogin,
      totalSpent: totalSpent,
      ordersCount: ordersCount,
      addresses: addresses.map((a) => a.toModel()).toList(),
    );
  }
}

extension UserAddressModelMapper on UserAddress {
  UserAddressEntity toEntity() {
    return UserAddressEntity(
      id: id,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension UserAddressEntityMapper on UserAddressEntity {
  UserAddress toModel() {
    return UserAddress(
      id: id,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension UsersStatsModelMapper on UsersStatsModel {
  UsersStatsEntity toEntity() {
    return UsersStatsEntity(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      inactiveUsers: inactiveUsers,
      users: users.map((u) => u.toEntity()).toList(),
    );
  }
}

extension UsersStatsEntityMapper on UsersStatsEntity {
  UsersStatsModel toModel() {
    return UsersStatsModel(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      inactiveUsers: inactiveUsers,
      users: users.map((u) => u.toModel()).toList(),
    );
  }
}
