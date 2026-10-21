import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(
    String name,
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    return await repository.signup(
      name,
      email,
      password,
      cancelToken: cancelToken,
    );
  }
}
