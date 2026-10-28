import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/clear_app_cache_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import 'settings_controller.dart';
import 'settings_state.dart';

// ==========================================
// Local & Remote Data Source Providers
// ==========================================

/// Hive Box provider for local settings cache
final settingsBoxProvider = Provider<Box>((ref) {
  return Hive.box('settings_cache');
});

/// Local Data Source provider
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsLocalDataSourceImpl(box: box);
});

/// Remote Data Source provider
final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return SettingsRemoteDataSourceImpl(dio: dio);
});

// ==========================================
// Repository Provider (Single Source of Truth)
// ==========================================

/// Settings repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);
  final localDataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ==========================================
// UseCase Providers
// ==========================================

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  return GetSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  return UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final clearAppCacheUseCaseProvider = Provider<ClearAppCacheUseCase>((ref) {
  return ClearAppCacheUseCase(ref.watch(settingsRepositoryProvider));
});

// ==========================================
// Presentation State Controller Provider
// ==========================================

/// Scoped Notifier provider for Settings state management
final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);
