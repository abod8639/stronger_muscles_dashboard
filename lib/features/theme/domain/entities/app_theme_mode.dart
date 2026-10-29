/// Pure Dart enum representing the application theme mode.
/// 100% framework-independent (zero Flutter UI imports).
enum AppThemeMode {
  light,
  dark,
  system;

  bool get isLight => this == AppThemeMode.light;
  bool get isDark => this == AppThemeMode.dark;
  bool get isSystem => this == AppThemeMode.system;

  String get displayName {
    switch (this) {
      case AppThemeMode.light:
        return 'الوضع النهاري (Light)';
      case AppThemeMode.dark:
        return 'الوضع الليلي (Dark)';
      case AppThemeMode.system:
        return 'حسب إعدادات النظام (System)';
    }
  }

  String get storageKey {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  static AppThemeMode fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'light':
        return AppThemeMode.light;
      case 'system':
        return AppThemeMode.system;
      case 'dark':
      default:
        return AppThemeMode.dark;
    }
  }
}
