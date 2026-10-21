import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        email,
        password,
        cancelToken: cancelToken,
      );

      if (authModel.token != null && authModel.token!.isNotEmpty) {
        await localDataSource.saveToken(authModel.token!);
      }
      await localDataSource.saveUser(authModel.toJson());

      return Right(authModel);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signup(
    String name,
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    try {
      final authModel = await remoteDataSource.signup(
        name,
        email,
        password,
        cancelToken: cancelToken,
      );

      if (authModel.token != null && authModel.token!.isNotEmpty) {
        await localDataSource.saveToken(authModel.token!);
      }
      await localDataSource.saveUser(authModel.toJson());

      return Right(authModel);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await localDataSource.clearToken();
      return const Right(unit);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  bool isLoggedIn() {
    return localDataSource.hasToken();
  }

  @override
  String? getToken() {
    return localDataSource.getToken();
  }

  @override
  Either<Failure, AuthEntity?> getCurrentUser() {
    try {
      final userMap = localDataSource.getUser();
      if (userMap != null) {
        return Right(AuthModel.fromJson(userMap));
      }
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
