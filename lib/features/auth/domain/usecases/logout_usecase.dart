import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// 100% Pure Dart UseCase for administrator logout.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return await _repository.logout();
  }
}
