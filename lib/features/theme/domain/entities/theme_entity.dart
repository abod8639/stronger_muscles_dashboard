import 'app_theme_mode.dart';

/// Pure Dart domain entity representing user theme preferences.
/// 100% framework-independent with zero imports from Flutter UI or 3rd-party SDKs.
class ThemeEntity {
  final AppThemeMode mode;
  final DateTime? updatedAt;

  const ThemeEntity({this.mode = AppThemeMode.dark, this.updatedAt});

  ThemeEntity copyWith({AppThemeMode? mode, DateTime? updatedAt}) {
    return ThemeEntity(
      mode: mode ?? this.mode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeEntity &&
        other.mode == mode &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(mode, updatedAt);

  @override
  String toString() =>
      'ThemeEntity(mode: ${mode.storageKey}, updatedAt: $updatedAt)';
}
