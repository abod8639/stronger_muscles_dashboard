import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/theme_local_datasource.dart';
import '../../data/datasources/theme_remote_datasource.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/get_theme_usecase.dart';
import '../../domain/usecases/set_theme_usecase.dart';
import '../../domain/usecases/toggle_theme_usecase.dart';
import 'theme_controller.dart';

// ==========================================
// Local & Remote Data Source Providers
// ==========================================

/// Hive Box provider for local theme persistence
final themeBoxProvider = Provider<Box>((ref) {
  return Hive.box('theme_cache');
});

/// Local Data Source provider
final themeLocalDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  final box = ref.watch(themeBoxProvider);
  return ThemeLocalDataSourceImpl(box: box);
});

/// Remote Data Source provider
final themeRemoteDataSourceProvider = Provider<ThemeRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ThemeRemoteDataSourceImpl(dio: dio);
});

// ==========================================
// Repository Provider (Single Source of Truth)
// ==========================================

/// Theme repository provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final localDataSource = ref.watch(themeLocalDataSourceProvider);
  final remoteDataSource = ref.watch(themeRemoteDataSourceProvider);
  return ThemeRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// ==========================================
// Domain UseCase Providers
// ==========================================

final getThemeUseCaseProvider = Provider<GetThemeUseCase>((ref) {
  return GetThemeUseCase(ref.watch(themeRepositoryProvider));
});

final setThemeUseCaseProvider = Provider<SetThemeUseCase>((ref) {
  return SetThemeUseCase(ref.watch(themeRepositoryProvider));
});

final toggleThemeUseCaseProvider = Provider<ToggleThemeUseCase>((ref) {
  return ToggleThemeUseCase(ref.watch(themeRepositoryProvider));
});

// ==========================================
// Presentation Notifier Provider
// ==========================================

/// Central theme mode notifier provider for MaterialApp
final themeControllerProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
