import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/data/services/auth_service.dart';
import 'package:stronger_muscles_dashboard/functions/getx_init.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'package:stronger_muscles_dashboard/main_navigation_screen.dart';
import 'config/theme.dart';
import 'config/theme_extended.dart';
import 'screens/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await GetStorage.init();
  await hiveInit();
  initializeServices();

  runApp(const StrongerMusclesDashboard());
}

class StrongerMusclesDashboard extends StatelessWidget {
  const StrongerMusclesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة تسجيل الدخول
    final authService = Get.put(AuthService());
    final isLoggedIn = authService.isLoggedIn();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم Stronger Muscles',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppThemeExtended.getDarkTheme(),
      themeMode: ThemeMode.dark,
      initialRoute: isLoggedIn ? '/dashboard' : '/login',
      getPages: [
        GetPage(name: '/dashboard', page: () => const MainNavigationScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
      ],
    );
  }
}
