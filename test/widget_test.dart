import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/main.dart';

class MockAuthService extends AuthService {
  @override
  bool isLoggedIn() => false;
  @override
  String? getToken() => null;
  @override
  Map<String, String> getAuthHeaders() => {'Accept': 'application/json'};
}

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

  setUp(() async {
    await GetStorage.init();
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    if (!Hive.isBoxOpen('theme_cache')) {
      await Hive.openBox('theme_cache');
    }
  });

  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(MockAuthService())],
        child: const StrongerMusclesDashboard(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((Widget widget) => widget is Scaffold),
      findsWidgets,
    );
  });
}
