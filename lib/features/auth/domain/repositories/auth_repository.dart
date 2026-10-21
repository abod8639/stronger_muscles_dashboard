import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, AuthEntity>> signup(
    String name,
    String email,
    String password, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> logout();

  bool isLoggedIn();

  String? getToken();

  Either<Failure, AuthEntity?> getCurrentUser();
}
