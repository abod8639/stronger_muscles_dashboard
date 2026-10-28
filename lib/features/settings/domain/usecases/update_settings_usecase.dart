import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Pure Dart usecase for updating store & app settings.
class UpdateSettingsUseCase {
  final SettingsRepository _repository;

  const UpdateSettingsUseCase(this._repository);

  Future<Either<Failure, SettingsEntity>> call(SettingsEntity settings) {
    return _repository.updateSettings(settings);
  }
}
