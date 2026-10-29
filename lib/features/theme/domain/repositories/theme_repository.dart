import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/app_theme_mode.dart';
import '../entities/theme_entity.dart';

/// Pure Dart abstract repository interface for theme management.
/// Strictly decoupled from Flutter UI, Hive, and Dio.
abstract class ThemeRepository {
  /// Retrieves the current stored theme preference.
  Future<Either<Failure, ThemeEntity>> getTheme();

  /// Persists a new theme mode.
  Future<Either<Failure, ThemeEntity>> setTheme(AppThemeMode mode);

  /// Toggles between light and dark theme modes.
  Future<Either<Failure, ThemeEntity>> toggleTheme();
}
