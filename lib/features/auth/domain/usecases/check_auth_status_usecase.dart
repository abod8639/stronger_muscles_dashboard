import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// 100% Pure Dart UseCase for checking authentication status.
class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  const CheckAuthStatusUseCase(this._repository);

  Future<Either<Failure, bool>> call() async {
    return await _repository.checkAuthStatus();
  }
}
