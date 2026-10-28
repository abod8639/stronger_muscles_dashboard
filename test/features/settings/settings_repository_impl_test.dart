import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/models/settings_model.dart';
import 'package:stronger_muscles_dashboard/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/settings/domain/entities/settings_entity.dart';

class MockSettingsRemoteDataSource implements SettingsRemoteDataSource {
  SettingsModel? mockSettings;
  Exception? exceptionToThrow;

  @override
  Future<SettingsModel> getSettings() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockSettings ?? SettingsModel.defaultSettings;
  }

  @override
  Future<SettingsModel> updateSettings(Map<String, dynamic> settingsData) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return SettingsModel.fromJson(settingsData);
  }
}

class MockSettingsLocalDataSource implements SettingsLocalDataSource {
  SettingsModel? storedSettings;
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<SettingsModel?> getCachedSettings() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedSettings;
  }

  @override
  Future<void> cacheSettings(SettingsModel settings) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedSettings = settings;
  }

  @override
  Future<bool> isCacheValid() async {
    return cacheValid;
  }

  @override
  Future<void> clearCache() async {
    storedSettings = null;
  }
}

void main() {
  late MockSettingsRemoteDataSource mockRemote;
  late MockSettingsLocalDataSource mockLocal;
  late SettingsRepositoryImpl repository;

  const testModel = SettingsModel(
    storeName: 'Test Store',
    supportEmail: 'test@sm.com',
    supportPhone: '+9647700000000',
    currency: 'IQD',
    deliveryFee: 5000.0,
    freeDeliveryThreshold: 100000.0,
    isStoreOpen: true,
    orderNotificationsEnabled: true,
    maintenanceMode: false,
    allowedAdminRoles: ['admin'],
  );

  setUp(() {
    mockRemote = MockSettingsRemoteDataSource();
    mockLocal = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('SettingsRepositoryImpl.getSettings', () {
    test('fetches from remote, updates Hive cache, and returns Right(SettingsEntity)', () async {
      mockRemote.mockSettings = testModel;

      final result = await repository.getSettings();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.storeName, 'Test Store');
          expect(entity.currency, 'IQD');
        },
      );
      expect(mockLocal.storedSettings?.storeName, 'Test Store');
    });

    test('falls back to local Hive cache when remote call fails', () async {
      mockRemote.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/settings'),
        error: 'Network connection failed',
        type: DioExceptionType.connectionError,
      );
      mockLocal.storedSettings = testModel;

      final result = await repository.getSettings();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right from cache fallback'),
        (entity) {
          expect(entity.storeName, 'Test Store');
        },
      );
    });

    test('returns Left(Failure) when remote and local cache both fail on network error', () async {
      mockRemote.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/settings'),
        error: 'Internal server error',
        type: DioExceptionType.badResponse,
      );
      mockLocal.storedSettings = null;

      final result = await repository.getSettings();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Expected Left'),
      );
    });
  });

  group('SettingsRepositoryImpl.updateSettings & clearAppCache', () {
    const updatedEntity = SettingsEntity(
      storeName: 'Updated Stronger Muscles',
      supportEmail: 'new@sm.com',
      supportPhone: '+9647711111111',
      currency: 'USD',
      deliveryFee: 7000.0,
      freeDeliveryThreshold: 150000.0,
      isStoreOpen: false,
      orderNotificationsEnabled: false,
      maintenanceMode: true,
      allowedAdminRoles: ['super_admin'],
    );

    test('updateSettings updates remote, saves to local cache, and returns Right(SettingsEntity)', () async {
      final result = await repository.updateSettings(updatedEntity);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.storeName, 'Updated Stronger Muscles');
          expect(entity.currency, 'USD');
          expect(entity.isStoreOpen, isFalse);
        },
      );
      expect(mockLocal.storedSettings?.storeName, 'Updated Stronger Muscles');
    });

    test('clearAppCache clears local cache and returns Right(unit)', () async {
      mockLocal.storedSettings = testModel;

      final result = await repository.clearAppCache();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (u) {
          expect(u, equals(unit));
        },
      );
      expect(mockLocal.storedSettings, isNull);
    });
  });
}
