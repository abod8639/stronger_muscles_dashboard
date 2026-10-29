import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/models/admin_notification_model.dart';
import 'package:stronger_muscles_dashboard/features/notifications/data/repositories/notification_repository_impl.dart';

class MockNotificationLocalDataSource implements NotificationLocalDataSource {
  NotificationsResultModel? cachedModel;
  bool cacheValid = false;

  @override
  Future<NotificationsResultModel?> getCachedNotifications() async =>
      cachedModel;

  @override
  Future<void> cacheNotifications(NotificationsResultModel model) async {
    cachedModel = model;
    cacheValid = true;
  }

  @override
  Future<bool> isCacheValid() async => cacheValid;

  @override
  Future<void> clearCache() async {
    cachedModel = null;
    cacheValid = false;
  }
}

class MockNotificationRemoteDataSource implements NotificationRemoteDataSource {
  NotificationsResultModel? remoteResult;
  AdminNotificationModel? sentNotification;
  Exception? exceptionToThrow;

  @override
  Future<NotificationsResultModel> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteResult ?? const NotificationsResultModel.empty();
  }

  @override
  Future<AdminNotificationModel> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return sentNotification ??
        AdminNotificationModel(
          id: 'new_1',
          title: data['title']?.toString() ?? '',
          body: data['body']?.toString() ?? '',
          type: data['type']?.toString() ?? 'general',
          targetType: data['target_type']?.toString() ?? 'all',
        );
  }

  @override
  Future<void> deleteNotification(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }
}

void main() {
  late MockNotificationLocalDataSource localDataSource;
  late MockNotificationRemoteDataSource remoteDataSource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    localDataSource = MockNotificationLocalDataSource();
    remoteDataSource = MockNotificationRemoteDataSource();
    repository = NotificationRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('NotificationRepositoryImpl Tests', () {
    const tModel = NotificationsResultModel(
      notifications: [
        AdminNotificationModel(
          id: '1',
          title: 'System update',
          body: 'Maintenance tonight',
          type: 'system',
          targetType: 'all',
        ),
      ],
      totalCount: 1,
      todayCount: 1,
      broadcastCount: 1,
      targetedCount: 0,
    );

    test(
      'returns cached notifications immediately when cache is valid and not forced',
      () async {
        localDataSource.cachedModel = tModel;
        localDataSource.cacheValid = true;

        final result = await repository.getNotifications();

        expect(result.isRight(), isTrue);
        result.fold((l) => fail('Should succeed with cache'), (r) {
          expect(r.totalCount, 1);
          expect(r.notifications.first.title, 'System update');
        });
      },
    );

    test(
      'calls remote and updates local cache when cache is invalid',
      () async {
        localDataSource.cacheValid = false;
        remoteDataSource.remoteResult = tModel;

        final result = await repository.getNotifications();

        expect(result.isRight(), isTrue);
        expect(localDataSource.cachedModel, equals(tModel));
        result.fold(
          (l) => fail('Should succeed from remote'),
          (r) => expect(r.totalCount, 1),
        );
      },
    );

    test(
      'falls back to cache when remote throws exception (offline resilience)',
      () async {
        localDataSource.cachedModel = tModel;
        localDataSource.cacheValid = false;
        remoteDataSource.exceptionToThrow = ServerException(
          message: 'Server offline',
        );

        final result = await repository.getNotifications();

        expect(result.isRight(), isTrue);
        result.fold(
          (l) => fail('Should fallback to cached data'),
          (r) => expect(r.totalCount, 1),
        );
      },
    );

    test('returns Failure when remote fails and no cache exists', () async {
      localDataSource.cachedModel = null;
      localDataSource.cacheValid = false;
      remoteDataSource.exceptionToThrow = ServerException(
        message: 'No connection',
      );

      final result = await repository.getNotifications();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (r) => fail('Should return failure'),
      );
    });

    test(
      'sendNotification invalidates cache and returns Right(entity)',
      () async {
        localDataSource.cachedModel = tModel;
        localDataSource.cacheValid = true;

        final payload = {
          'title': 'New Promo',
          'body': 'Check our discounts',
          'type': 'promo',
          'target_type': 'all',
        };

        final result = await repository.sendNotification(payload);

        expect(result.isRight(), isTrue);
        expect(localDataSource.cachedModel, isNull);
        result.fold((l) => fail('Should send notification'), (entity) {
          expect(entity.id, 'new_1');
          expect(entity.title, 'New Promo');
        });
      },
    );

    test(
      'deleteNotification invalidates cache and returns Right(null)',
      () async {
        localDataSource.cachedModel = tModel;
        localDataSource.cacheValid = true;

        final result = await repository.deleteNotification('1');

        expect(result.isRight(), isTrue);
        expect(localDataSource.cachedModel, isNull);
      },
    );
  });
}
