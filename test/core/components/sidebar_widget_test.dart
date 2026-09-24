import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';

class RoleMockAuthService extends AuthService {
  final String mockRole;
  final String mockName;

  RoleMockAuthService({required this.mockRole, required this.mockName});

  @override
  String getUserRole() => mockRole;

  @override
  String getUserName() => mockName;

  @override
  bool isLoggedIn() => true;
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
    Get.put<NavigationController>(NavigationController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Sidebar renders full menu for super_admin role', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    Get.put<AuthService>(
      RoleMockAuthService(mockRole: 'super_admin', mockName: 'Master Admin'),
      permanent: true,
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: Sidebar(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Master Admin'), findsOneWidget);
    expect(find.text('Super Admin'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Ads'), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Sidebar hides restricted items for customer_support role', (WidgetTester tester) async {
    Get.put<AuthService>(
      RoleMockAuthService(mockRole: 'customer_support', mockName: 'Support Agent'),
      permanent: true,
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: Sidebar(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Support Agent'), findsOneWidget);
    expect(find.text('Customer Support'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);

    // Products, Ads, Users, Categories, Settings should be hidden
    expect(find.text('Products'), findsNothing);
    expect(find.text('Ads'), findsNothing);
    expect(find.text('Users'), findsNothing);
    expect(find.text('Categories'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });
}
