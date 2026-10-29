import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/users/data/mappers/user_mapper.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_address.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/users_stats_model.dart';

void main() {
  group('UserAddress and UserAddressEntity', () {
    const addressModel = UserAddress(
      id: 'addr_1',
      label: 'Home',
      fullName: 'Ahmed Ali',
      phone: '01012345678',
      street: 'Tahrir St',
      city: 'Cairo',
      state: 'Cairo',
      postalCode: '11511',
      country: 'Egypt',
      isDefault: true,
      latitude: 30.0444,
      longitude: 31.2357,
    );

    test('UserAddress toEntity mapping produces correct UserAddressEntity', () {
      final entity = addressModel.toEntity();
      expect(entity.id, 'addr_1');
      expect(entity.label, 'Home');
      expect(entity.fullName, 'Ahmed Ali');
      expect(entity.phone, '01012345678');
      expect(entity.street, 'Tahrir St');
      expect(entity.city, 'Cairo');
      expect(entity.state, 'Cairo');
      expect(entity.country, 'Egypt');
      expect(entity.isDefault, true);
      expect(entity.latitude, 30.0444);
      expect(entity.longitude, 31.2357);
      expect(entity.fullAddress, 'Tahrir St, Cairo, Cairo, Egypt');
    });

    test('UserAddressEntity toModel mapping produces matching UserAddress', () {
      final entity = addressModel.toEntity();
      final model = entity.toModel();
      expect(model.id, entity.id);
      expect(model.label, entity.label);
      expect(model.street, entity.street);
      expect(model.isDefault, entity.isDefault);
    });

    test('UserAddressEntity copyWith and equality work as expected', () {
      final entity1 = addressModel.toEntity();
      final entity2 = entity1.copyWith(label: 'Work');
      expect(entity2.label, 'Work');
      expect(entity2.street, entity1.street);
      expect(entity1 == entity2, false);

      final entity3 = entity2.copyWith(label: 'Home');
      expect(entity1 == entity3, true);
      expect(entity1.hashCode, entity3.hashCode);
    });
  });

  group('UserModel and UserEntity', () {
    const userModel = UserModel(
      id: 10,
      name: 'Mahmoud Hassan',
      email: 'mahmoud@example.com',
      photoUrl: 'https://example.com/avatar.jpg',
      phoneNumber: '01234567890',
      role: 'admin',
      isActive: true,
      totalSpent: 450.75,
      ordersCount: 5,
      addresses: [
        UserAddress(
          id: 'addr_1',
          label: 'Office',
          street: 'Main Rd',
          city: 'Alexandria',
        ),
      ],
    );

    test('UserModel toEntity mapping maps all fields correctly', () {
      final entity = userModel.toEntity();
      expect(entity.id, 10);
      expect(entity.name, 'Mahmoud Hassan');
      expect(entity.email, 'mahmoud@example.com');
      expect(entity.role, 'admin');
      expect(entity.isActive, true);
      expect(entity.totalSpent, 450.75);
      expect(entity.ordersCount, 5);
      expect(entity.addresses.length, 1);
      expect(entity.addresses.first.city, 'Alexandria');
    });

    test('UserEntity toModel mapping maps back properly', () {
      final entity = userModel.toEntity();
      final model = entity.toModel();
      expect(model.id, entity.id);
      expect(model.name, entity.name);
      expect(model.email, entity.email);
      expect(model.role, entity.role);
    });

    test('UserEntity copyWith and equality work as expected', () {
      final entity1 = userModel.toEntity();
      final entity2 = entity1.copyWith(name: 'Ali Hassan');
      expect(entity2.name, 'Ali Hassan');
      expect(entity1 == entity2, false);

      final entity3 = entity2.copyWith(name: 'Mahmoud Hassan');
      expect(entity1 == entity3, true);
      expect(entity1.hashCode, entity3.hashCode);
    });
  });

  group('UsersStatsModel and UsersStatsEntity', () {
    const statsModel = UsersStatsModel(
      totalUsers: 100,
      activeUsers: 85,
      inactiveUsers: 15,
      users: [
        UserModel(
          id: 1,
          name: 'User 1',
          role: 'customer',
          isActive: true,
        ),
        UserModel(
          id: 2,
          name: 'User 2',
          role: 'customer',
          isActive: false,
        ),
      ],
    );

    test('UsersStatsModel toEntity mapping works correctly', () {
      final entity = statsModel.toEntity();
      expect(entity.totalUsers, 100);
      expect(entity.activeUsers, 85);
      expect(entity.inactiveUsers, 15);
      expect(entity.users.length, 2);
      expect(entity.users.first.name, 'User 1');
      expect(entity.users.last.isActive, false);
    });

    test('UsersStatsEntity toModel mapping maps back properly', () {
      final entity = statsModel.toEntity();
      final model = entity.toModel();
      expect(model.totalUsers, entity.totalUsers);
      expect(model.activeUsers, entity.activeUsers);
      expect(model.inactiveUsers, entity.inactiveUsers);
      expect(model.users.length, entity.users.length);
    });

    test('UsersStatsEntity copyWith and equality work as expected', () {
      final entity1 = statsModel.toEntity();
      final entity2 = entity1.copyWith(totalUsers: 150);
      expect(entity2.totalUsers, 150);
      expect(entity1 == entity2, false);

      final entity3 = entity2.copyWith(totalUsers: 100);
      expect(entity1 == entity3, true);
      expect(entity1.hashCode, entity3.hashCode);
    });
  });
}
