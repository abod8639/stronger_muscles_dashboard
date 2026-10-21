import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/router/app_router.dart';
import 'package:stronger_muscles_dashboard/functions/getx_init.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'config/theme_extended.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await GetStorage.init();
  await hiveInit();
  initializeServices();

  // تهيئة خدمة التوثيق مبكراً
  if (!Get.isRegistered<AuthService>()) {
    Get.put(AuthService(), permanent: true);
  }

  runApp(
    const ProviderScope(
      child: StrongerMusclesDashboard(),
    ),
  );
}

class StrongerMusclesDashboard extends ConsumerWidget {
  const StrongerMusclesDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم Stronger Muscles',
      theme: AppThemeExtended.getLightTheme(),
      darkTheme: AppThemeExtended.getDarkTheme(),
      themeMode: ThemeMode.dark,
    );
  }
}
