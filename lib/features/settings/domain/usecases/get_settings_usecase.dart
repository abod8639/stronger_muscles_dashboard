import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Pure Dart usecase for retrieving store & app settings.
class GetSettingsUseCase {
  final SettingsRepository _repository;

  const GetSettingsUseCase(this._repository);

  Future<Either<Failure, SettingsEntity>> call() {
    return _repository.getSettings();
  }
}
