import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/screens/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/services/auth_service.dart';
import 'config/theme.dart';
import 'config/theme_extended.dart';
import 'screens/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await GetStorage.init();
  await hiveInit();
  runApp(const StrongerMusclesDashboard());
}

class StrongerMusclesDashboard extends StatelessWidget {
  const StrongerMusclesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // final isLoggedIn = AuthService().isLoggedIn();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم Stronger Muscles',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppThemeExtended.getDarkTheme(),
      themeMode: ThemeMode.dark,
      // initialRoute: isLoggedIn ? '/dashboard' : '/login',
      initialRoute: '/dashboard',
      getPages: [
        GetPage(name: '/dashboard', page: () => const MainNavigationScreen()),
        // GetPage(name: '/login', page: () => const LoginScreen()),
        // GetPage(name: '/signup', page: () => const SignupScreen()),
      ],
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.backgroundDark,
          drawer: isDesktop ? null : myDrawer(),
          body: Stack(
            children: [
              // Ambient Gradient Background
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -150,
                left: -150,
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main Layout
              Row(
                children: [
                  if (isDesktop) const Sidebar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                        right: 10,
                        left: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Obx(
                          () => IndexedStack(
                            index: controller.selectedIndex.value,
                            children: const [
                              DashboardScreen(),
                              CategoriesScreen(),
                              ProductsScreen(),
                              OrdersScreen(),
                              UsersScreen(),
                              SettingsScreen(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : MyBottomNavigationBar(),
        );
      },
    );
  }
}
