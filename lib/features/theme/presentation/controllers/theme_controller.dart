import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// حالة نمط الثيم (Light / Dark / System)
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

/// موفر حالة الثيم المركزي
final themeControllerProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
