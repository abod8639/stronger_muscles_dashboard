import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/core/router/app_router.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/functions/hive_init.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/theme/theme_feature.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await GetStorage.init();
    await hiveInit();
  } catch (e, stack) {
    debugPrint('⚠️ Storage/Hive initialization error: $e\n$stack');
  }

  runApp(const ProviderScope(child: StrongerMusclesDashboard()));
}

class StrongerMusclesDashboard extends ConsumerWidget {
  const StrongerMusclesDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم Stronger Muscles',
      theme: AppThemeExtended.getLightTheme(),
      darkTheme: AppThemeExtended.getDarkTheme(),
      themeMode: themeMode,
    );
  }
}
