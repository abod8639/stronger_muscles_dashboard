import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Pure Dart UseCase for updating the administrator's Gemini AI API key and model in the database.
class UpdateAdminAiConfigUseCase {
  final AuthRepository _repository;

  const UpdateAdminAiConfigUseCase({required AuthRepository repository})
      : _repository = repository;

  Future<Either<Failure, AuthEntity>> call({
    required String apiKey,
    required String model,
  }) {
    return _repository.updateAiConfig(
      apiKey: apiKey,
      model: model,
    );
  }
}

