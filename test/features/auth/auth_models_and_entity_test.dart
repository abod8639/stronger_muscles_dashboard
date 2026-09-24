import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/models/auth_model.dart';
import 'package:stronger_muscles_dashboard/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity & Role Tests', () {
    test('default role is admin and permissions reflect admin role', () {
      const entity = AuthEntity(
        id: '1',
        name: 'Admin User',
        email: 'admin@test.com',
      );

      expect(entity.role, 'admin');
      expect(entity.isSuperAdmin, false);
      expect(entity.canManageUsers, true);
      expect(entity.canManageProducts, true);
      expect(entity.canManageCategories, true);
      expect(entity.canManageOrders, true);
    });

    test('super_admin role permissions are all true', () {
      const entity = AuthEntity(
        id: '2',
        name: 'Super Admin',
        email: 'super@test.com',
        role: 'super_admin',
      );

      expect(entity.isSuperAdmin, true);
      expect(entity.canManageUsers, true);
      expect(entity.canManageProducts, true);
      expect(entity.canManageCategories, true);
      expect(entity.canManageOrders, true);
    });

    test('customer_support role permissions are restricted', () {
      const entity = AuthEntity(
        id: '3',
        name: 'Support Agent',
        email: 'support@test.com',
        role: 'customer_support',
      );

      expect(entity.isSuperAdmin, false);
      expect(entity.canManageUsers, false);
      expect(entity.canManageProducts, false);
      expect(entity.canManageCategories, false);
      expect(entity.canManageOrders, true);
    });
  });

  group('AuthModel Serialization Tests', () {
    test('fromJson parses nested user object with role', () {
      final json = {
        'token': 'secret-token-123',
        'user': {
          'id': 10,
          'name': 'Test Admin',
          'email': 'test@example.com',
          'role': 'super_admin',
          'profile_image': 'https://example.com/photo.jpg',
        },
      };

      final model = AuthModel.fromJson(json);

      expect(model.id, '10');
      expect(model.name, 'Test Admin');
      expect(model.email, 'test@example.com');
      expect(model.role, 'super_admin');
      expect(model.token, 'secret-token-123');
      expect(model.profileImage, 'https://example.com/photo.jpg');
      expect(model.isSuperAdmin, true);
    });

    test('fromJson defaults role to admin if omitted', () {
      final json = {
        'id': '5',
        'name': 'Fallback Admin',
        'email': 'fallback@test.com',
      };

      final model = AuthModel.fromJson(json);

      expect(model.role, 'admin');
      expect(model.canManageUsers, true);
    });

    test('toJson serializes all fields correctly', () {
      const model = AuthModel(
        id: '99',
        name: 'Json Tester',
        email: 'tester@test.com',
        role: 'inventory_manager',
        token: 'token-xyz',
        profileImage: 'avatar.png',
      );

      final json = model.toJson();

      expect(json['id'], '99');
      expect(json['name'], 'Json Tester');
      expect(json['email'], 'tester@test.com');
      expect(json['role'], 'inventory_manager');
      expect(json['token'], 'token-xyz');
      expect(json['profile_image'], 'avatar.png');
    });
  });
}
