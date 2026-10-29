import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/usecases/get_theme_usecase.dart';
import '../../domain/usecases/set_theme_usecase.dart';
import '../../domain/usecases/toggle_theme_usecase.dart';
import 'theme_providers.dart';

/// Presentation state controller managing the application theme mode.
/// Adheres strictly to Clean Architecture:
/// - Pure functional error handling with ZERO raw try-catch blocks
/// - 100% unit testable via Constructor Dependency Injection
/// - Backed by Hive local persistence through domain use cases
class ThemeNotifier extends Notifier<ThemeMode> {
  final GetThemeUseCase? _injectedGetThemeUseCase;
  final SetThemeUseCase? _injectedSetThemeUseCase;
  final ToggleThemeUseCase? _injectedToggleThemeUseCase;

  ThemeNotifier({
    GetThemeUseCase? getThemeUseCase,
    SetThemeUseCase? setThemeUseCase,
    ToggleThemeUseCase? toggleThemeUseCase,
  }) : _injectedGetThemeUseCase = getThemeUseCase,
       _injectedSetThemeUseCase = setThemeUseCase,
       _injectedToggleThemeUseCase = toggleThemeUseCase;

  GetThemeUseCase get _getThemeUseCase =>
      _injectedGetThemeUseCase ?? ref.read(getThemeUseCaseProvider);

  SetThemeUseCase get _setThemeUseCase =>
      _injectedSetThemeUseCase ?? ref.read(setThemeUseCaseProvider);

  ToggleThemeUseCase get _toggleThemeUseCase =>
      _injectedToggleThemeUseCase ?? ref.read(toggleThemeUseCaseProvider);

  @override
  ThemeMode build() {
    // Schedule asynchronous loading of saved theme from Hive cache
    Future.microtask(() => loadTheme());
    return ThemeMode.dark;
  }

  /// Loads the persisted theme from repository
  Future<void> loadTheme() async {
    final result = await _getThemeUseCase.call();
    result.fold(
      (failure) {
        // Fallback default on failure is dark mode
        state = ThemeMode.dark;
      },
      (themeEntity) {
        state = _mapToFlutterThemeMode(themeEntity.mode);
      },
    );
  }

  /// Sets the theme mode using Flutter's [ThemeMode]
  Future<void> setThemeMode(ThemeMode mode) async {
    final appMode = _mapToAppThemeMode(mode);
    final result = await _setThemeUseCase.call(appMode);
    result.fold((failure) {}, (themeEntity) {
      state = _mapToFlutterThemeMode(themeEntity.mode);
    });
  }

  /// Toggles between Light and Dark themes
  Future<void> toggleTheme() async {
    final result = await _toggleThemeUseCase.call();
    result.fold((failure) {}, (themeEntity) {
      state = _mapToFlutterThemeMode(themeEntity.mode);
    });
  }

  static ThemeMode _mapToFlutterThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static AppThemeMode _mapToAppThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppThemeMode.light;
      case ThemeMode.dark:
        return AppThemeMode.dark;
      case ThemeMode.system:
        return AppThemeMode.system;
    }
  }
}
