import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/features/auth/data/datasources/auth_local_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return Directory.systemTemp.path;
      },
    );
  });

  late GetStorage storage;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() async {
    await GetStorage.init('test_auth_storage');
    storage = GetStorage('test_auth_storage');
    await storage.erase();
    dataSource = AuthLocalDataSourceImpl(storage: storage);
  });

  tearDown(() async {
    await storage.erase();
  });

  group('AuthLocalDataSourceImpl Tests', () {
    test('token save, read, check, and clear cycle works properly', () async {
      expect(await dataSource.hasToken(), false);
      expect(await dataSource.getToken(), isNull);

      await dataSource.saveToken('jwt-token-999');

      expect(await dataSource.hasToken(), true);
      expect(await dataSource.getToken(), 'jwt-token-999');

      await dataSource.clearToken();

      expect(await dataSource.hasToken(), false);
      expect(await dataSource.getToken(), isNull);
    });

    test('user save, read, and clear works properly', () async {
      expect(await dataSource.getUser(), isNull);

      final userPayload = {
        'id': '1',
        'name': 'Dexter Admin',
        'email': 'dexter@admin.com',
        'role': 'super_admin',
      };

      await dataSource.saveUser(userPayload);

      final retrieved = await dataSource.getUser();
      expect(retrieved, isNotNull);
      expect(retrieved!['name'], 'Dexter Admin');
      expect(retrieved['role'], 'super_admin');

      await dataSource.clearAll();
      expect(await dataSource.getUser(), isNull);
    });
  });
}
