import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/app_theme_mode.dart';
import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

/// Pure Dart usecase for updating the application theme mode.
class SetThemeUseCase {
  final ThemeRepository _repository;

  const SetThemeUseCase(this._repository);

  Future<Either<Failure, ThemeEntity>> call(AppThemeMode mode) {
    return _repository.setTheme(mode);
  }
}
