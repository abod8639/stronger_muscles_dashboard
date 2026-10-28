import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/mappers/settings_mapper.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/models/settings_model.dart';
import 'package:stronger_muscles_dashboard/features/settings/domain/entities/settings_entity.dart';

void main() {
  group('SettingsEntity Tests', () {
    test('value equality, hashCode, and copyWith contract', () {
      final now = DateTime(2026, 1, 1);
      final s1 = SettingsEntity(
        storeName: 'Stronger Muscles',
        supportEmail: 'support@sm.com',
        supportPhone: '+9647700000000',
        currency: 'IQD',
        deliveryFee: 5000.0,
        freeDeliveryThreshold: 100000.0,
        isStoreOpen: true,
        orderNotificationsEnabled: true,
        maintenanceMode: false,
        allowedAdminRoles: const ['admin', 'super_admin'],
        updatedAt: now,
      );

      final s2 = SettingsEntity(
        storeName: 'Stronger Muscles',
        supportEmail: 'support@sm.com',
        supportPhone: '+9647700000000',
        currency: 'IQD',
        deliveryFee: 5000.0,
        freeDeliveryThreshold: 100000.0,
        isStoreOpen: true,
        orderNotificationsEnabled: true,
        maintenanceMode: false,
        allowedAdminRoles: const ['admin', 'super_admin'],
        updatedAt: now,
      );

      final s3 = s1.copyWith(isStoreOpen: false, deliveryFee: 7000.0);

      expect(s1, equals(s2));
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1, isNot(equals(s3)));
      expect(s3.isStoreOpen, isFalse);
      expect(s3.deliveryFee, 7000.0);
      expect(s3.storeName, 'Stronger Muscles');
    });
  });

  group('SettingsModel & Mapper Tests', () {
    test('SettingsModel.fromJson and toJson serialization', () {
      final json = {
        'store_name': 'Gym Pro',
        'support_email': 'help@gympro.com',
        'support_phone': '+9647800000000',
        'currency': 'USD',
        'delivery_fee': 4000.0,
        'free_delivery_threshold': 80000.0,
        'is_store_open': true,
        'order_notifications_enabled': false,
        'maintenance_mode': true,
        'allowed_admin_roles': ['admin', 'manager'],
        'updated_at': '2026-06-15T10:00:00.000',
      };

      final model = SettingsModel.fromJson(json);

      expect(model.storeName, 'Gym Pro');
      expect(model.supportEmail, 'help@gympro.com');
      expect(model.currency, 'USD');
      expect(model.deliveryFee, 4000.0);
      expect(model.isStoreOpen, isTrue);
      expect(model.orderNotificationsEnabled, isFalse);
      expect(model.maintenanceMode, isTrue);
      expect(model.allowedAdminRoles, ['admin', 'manager']);

      final serialized = model.toJson();
      expect(serialized['store_name'], 'Gym Pro');
      expect(serialized['currency'], 'USD');
      expect(serialized['is_store_open'], isTrue);
      expect(serialized['maintenance_mode'], isTrue);
    });

    test('SettingsModelMapper and SettingsEntityMapper conversion', () {
      const entity = SettingsEntity(
        storeName: 'Iron Body',
        supportEmail: 'contact@ironbody.com',
        supportPhone: '+9647500000000',
        currency: 'IQD',
        deliveryFee: 6000.0,
        freeDeliveryThreshold: 120000.0,
        isStoreOpen: false,
        orderNotificationsEnabled: true,
        maintenanceMode: false,
      );

      final model = entity.toModel();
      expect(model.storeName, entity.storeName);
      expect(model.supportEmail, entity.supportEmail);
      expect(model.deliveryFee, entity.deliveryFee);
      expect(model.isStoreOpen, entity.isStoreOpen);

      final mappedEntity = model.toEntity();
      expect(mappedEntity, equals(entity));
    });
  });
}
