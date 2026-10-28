import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/settings_repository.dart';

/// Pure Dart usecase for clearing local application cache.
class ClearAppCacheUseCase {
  final SettingsRepository _repository;

  const ClearAppCacheUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.clearAppCache();
  }
}
