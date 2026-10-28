import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// 100% Pure Dart UseCase for administrator registration.
class SignupUseCase {
  final AuthRepository _repository;

  const SignupUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _repository.signup(
      name: name,
      email: email,
      password: password,
    );
  }
}
