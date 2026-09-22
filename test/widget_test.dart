import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
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
    Get.reset();
    await GetStorage.init();
    Get.put<AuthService>(MockAuthService(), permanent: true);
    Get.put<ApiBase>(ApiBase(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<CacheService>(CacheService(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StrongerMusclesDashboard());
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate((Widget widget) => widget is Scaffold),
      findsWidgets,
    );
  });
}
