import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_binding.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/pages/login_screen.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/pages/signup_screen.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/main_navigation_binding.dart';
import 'package:stronger_muscles_dashboard/main_navigation_screen.dart';
import 'package:stronger_muscles_dashboard/functions/getx_init.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'config/theme.dart';
import 'config/theme_extended.dart';

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
        GetPage(
          name: '/dashboard', 
          page: () => const MainNavigationScreen(),
          binding: MainNavigationBinding(),
          ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupScreen(),
          binding: AuthBinding(),
        ),
      ],
    );
  }


}

