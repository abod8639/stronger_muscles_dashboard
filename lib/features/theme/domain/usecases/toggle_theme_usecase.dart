import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

/// Pure Dart usecase for toggling the application theme between light and dark.
class ToggleThemeUseCase {
  final ThemeRepository _repository;

  const ToggleThemeUseCase(this._repository);

  Future<Either<Failure, ThemeEntity>> call() {
    return _repository.toggleTheme();
  }
}
