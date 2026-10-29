import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/settings_entity.dart';

/// Pure Dart repository interface for store and application settings.
/// Strictly decoupled from data implementations, Dio, Hive, or Flutter.
abstract class SettingsRepository {
  /// Fetches current application and store settings.
  Future<Either<Failure, SettingsEntity>> getSettings();

  /// Updates application and store settings.
  Future<Either<Failure, SettingsEntity>> updateSettings(
    SettingsEntity settings,
  );

  /// Clears local cached data across the application.
  Future<Either<Failure, Unit>> clearAppCache();
}
