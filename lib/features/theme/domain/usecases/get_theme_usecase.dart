import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

/// Pure Dart usecase for retrieving the active theme entity.
class GetThemeUseCase {
  final ThemeRepository _repository;

  const GetThemeUseCase(this._repository);

  Future<Either<Failure, ThemeEntity>> call() {
    return _repository.getTheme();
  }
}
