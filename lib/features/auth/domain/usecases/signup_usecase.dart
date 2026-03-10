import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<AuthEntity> call(String name, String email, String password) async {
    return await repository.signup(name, email, password);
  }
}
