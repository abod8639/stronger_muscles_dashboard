import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/mappers/notification_mapper.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/models/admin_notification_model.dart';
import 'package:stronger_muscles_dashboard/features/notifications/domain/entities/admin_notification_entity.dart';
import 'package:stronger_muscles_dashboard/features/notifications/domain/entities/notifications_result_entity.dart';

void main() {
  group('AdminNotificationEntity Tests', () {
    test('initial factory produces default empty entity', () {
      final entity = AdminNotificationEntity.initial();

      expect(entity.id, '');
      expect(entity.title, '');
      expect(entity.body, '');
      expect(entity.type, 'general');
      expect(entity.targetType, 'all');
      expect(entity.isRead, isFalse);
    });

    test('typeLabel returns corresponding Arabic descriptions', () {
      const general = AdminNotificationEntity(
        id: '1',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'all',
      );
      const promo = AdminNotificationEntity(
        id: '2',
        title: 'T',
        body: 'B',
        type: 'promo',
        targetType: 'all',
      );
      const order = AdminNotificationEntity(
        id: '3',
        title: 'T',
        body: 'B',
        type: 'order',
        targetType: 'all',
      );
      const system = AdminNotificationEntity(
        id: '4',
        title: 'T',
        body: 'B',
        type: 'system',
        targetType: 'all',
      );

      expect(general.typeLabel, 'عام');
      expect(promo.typeLabel, 'إعلان / عرض');
      expect(order.typeLabel, 'حالة طلب');
      expect(system.typeLabel, 'نظام / أمان');
    });

    test('targetLabel returns all users or targeted user details', () {
      const broadcast = AdminNotificationEntity(
        id: '1',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'all',
      );
      const targetedNamed = AdminNotificationEntity(
        id: '2',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'user',
        userId: '10',
        userName: 'Ahmed',
      );
      const targetedUnnamed = AdminNotificationEntity(
        id: '3',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'user',
        userId: '10',
      );

      expect(broadcast.targetLabel, 'جميع المستخدمين');
      expect(targetedNamed.targetLabel, 'المستخدم: Ahmed');
      expect(targetedUnnamed.targetLabel, 'مستخدم محدد (#10)');
    });

    test('copyWith produces updated entity immutably', () {
      final initial = AdminNotificationEntity.initial();
      final updated = initial.copyWith(
        id: '100',
        title: 'Title Updated',
        isRead: true,
      );

      expect(updated.id, '100');
      expect(updated.title, 'Title Updated');
      expect(updated.isRead, isTrue);
      expect(updated.type, 'general');
    });

    test('value equality and hashCode behave as expected', () {
      const e1 = AdminNotificationEntity(
        id: '1',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'all',
      );
      const e2 = AdminNotificationEntity(
        id: '1',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'all',
      );
      const e3 = AdminNotificationEntity(
        id: '2',
        title: 'T',
        body: 'B',
        type: 'general',
        targetType: 'all',
      );

      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1, isNot(equals(e3)));
    });
  });

  group('NotificationsResultEntity Tests', () {
    test('initial factory produces empty zeroed result', () {
      const result = NotificationsResultEntity.initial();

      expect(result.notifications, isEmpty);
      expect(result.totalCount, 0);
      expect(result.todayCount, 0);
      expect(result.broadcastCount, 0);
      expect(result.targetedCount, 0);
    });

    test('copyWith updates fields correctly', () {
      const initial = NotificationsResultEntity.initial();
      final updated = initial.copyWith(
        totalCount: 42,
        todayCount: 5,
      );

      expect(updated.totalCount, 42);
      expect(updated.todayCount, 5);
      expect(updated.broadcastCount, 0);
    });
  });

  group('AdminNotificationModel & Mapper Tests', () {
    test('fromJson parses nested user and admin maps safely', () {
      final json = {
        'id': '99',
        'title': 'Flash Sale',
        'body': '50% off on all proteins',
        'type': 'promo',
        'target_type': 'user',
        'user_id': '12',
        'user': {'name': 'Dexter', 'email': 'dexter@test.com'},
        'admin': {'name': 'SuperAdmin'},
        'image_url': 'https://image.png',
        'is_read': 1,
        'created_at': '2026-10-28T07:00:00Z',
      };

      final model = AdminNotificationModel.fromJson(json);

      expect(model.id, '99');
      expect(model.title, 'Flash Sale');
      expect(model.userName, 'Dexter');
      expect(model.userEmail, 'dexter@test.com');
      expect(model.adminName, 'SuperAdmin');
      expect(model.isRead, isTrue);
      expect(model.createdAt, isNotNull);

      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.userName, 'Dexter');
      expect(entity.isRead, isTrue);

      final backToModel = entity.toModel();
      expect(backToModel.id, entity.id);
      expect(backToModel.userName, entity.userName);
    });

    test('toJson produces round-trippable map', () {
      final original = AdminNotificationModel(
        id: '123',
        title: 'Alert',
        body: 'Server update',
        type: 'system',
        targetType: 'all',
        adminName: 'Root',
        isRead: false,
        createdAt: DateTime.utc(2026, 10, 28),
      );

      final json = original.toJson();
      final reconstructed = AdminNotificationModel.fromJson(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.title, original.title);
      expect(reconstructed.adminName, original.adminName);
      expect(reconstructed.type, original.type);
    });
  });

  group('NotificationsResultModel & Isolate Compute Tests', () {
    test('parseNotificationsResultCompute handles valid and malformed JSON safely', () {
      final validJson = {
        'data': [
          {
            'id': '1',
            'title': 'Test',
            'body': 'Content',
            'type': 'general',
            'target_type': 'all',
          }
        ],
        'stats': {
          'total': 1,
          'sent_today': 1,
          'broadcast': 1,
          'targeted': 0,
        }
      };

      final result = parseNotificationsResultCompute(validJson);
      expect(result.notifications.length, 1);
      expect(result.totalCount, 1);
      expect(result.todayCount, 1);
      expect(result.broadcastCount, 1);

      final entity = result.toEntity();
      expect(entity.totalCount, 1);
      expect(entity.notifications.first.title, 'Test');

      final fallbackResult = parseNotificationsResultCompute(null);
      expect(fallbackResult.notifications, isEmpty);
      expect(fallbackResult.totalCount, 0);
    });
  });
}
