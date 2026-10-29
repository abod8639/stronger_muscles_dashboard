import 'package:flutter/material.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/theme_entity.dart';

/// Immutable presentation state representing current theme mode and status.
@immutable
class ThemeState {
  final ThemeEntity theme;
  final bool isLoading;
  final String? errorMessage;

  const ThemeState({
    this.theme = const ThemeEntity(),
    this.isLoading = false,
    this.errorMessage,
  });

  /// Maps the pure Dart [AppThemeMode] to Flutter's [ThemeMode].
  ThemeMode get flutterThemeMode {
    switch (theme.mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeState copyWith({
    ThemeEntity? theme,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
        other.theme == theme &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(theme, isLoading, errorMessage);

  @override
  String toString() =>
      'ThemeState(mode: ${theme.mode.storageKey}, isLoading: $isLoading)';
}
