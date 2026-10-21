import 'package:dartz/dartz.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logout();
  }
}
