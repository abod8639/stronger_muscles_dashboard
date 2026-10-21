import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    return await repository.login(email, password, cancelToken: cancelToken);
  }
}
