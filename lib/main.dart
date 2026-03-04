import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/screens/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/data/services/cache_service.dart';
import 'config/theme.dart';
import 'config/theme_extended.dart';
import 'screens/index.dart';
import 'controllers/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await GetStorage.init();
  await hiveInit();

  // تسجيل الخدمات والـ Controllers كـ Singletons
  _initializeServices();

  runApp(const StrongerMusclesDashboard());
}

/// تهيئة الخدمات والـ Controllers
void _initializeServices() {
  // تسجيل CacheService كـ GetxService (يبقى في الذاكرة طوال حياة التطبيق)
  Get.put(CacheService(), permanent: true);

  // تسجيل Controllers كـ LazyPut (يتم إنشاؤها فقط عند الحاجة الأولى)
  // وتبقى في الذاكرة طالما التطبيق يعمل
  Get.lazyPut(() => NavigationController(), fenix: true);
  Get.lazyPut(() => DashboardController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => ProductsController(), fenix: true);
  Get.lazyPut(() => OrdersController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
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
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/dashboard', page: () => const MainNavigationScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
      ],
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.find() لاسترجاع NavigationController المسجل في _initializeServices()
    final controller = Get.find<NavigationController>();

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
                        AppColors.primary.withValues(alpha: 0.15),
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
                        AppColors.accent.withValues(alpha: 0.1),
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
