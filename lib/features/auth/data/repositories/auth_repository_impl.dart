import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_mapper.dart';
import '../models/auth_model.dart';

/// Single Source of Truth for Authentication.
/// Orchestrates data between [AuthRemoteDataSource] (Network) and [AuthLocalDataSource] (Cache).
/// Maps raw exceptions to strongly-typed [Failure] classes using `fpdart`'s [Either].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Caching token and user profile
      if (authModel.token != null && authModel.token!.trim().isNotEmpty) {
        await _localDataSource.saveToken(authModel.token!);
      }
      await _localDataSource.saveUser(authModel.toJson());

      return Right(authModel.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await _remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );

      // Caching token and user profile
      if (authModel.token != null && authModel.token!.trim().isNotEmpty) {
        await _localDataSource.saveToken(authModel.token!);
      }
      await _localDataSource.saveUser(authModel.toJson());

      return Right(authModel.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _localDataSource.clearAll();
      return const Right(unit);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final hasToken = await _localDataSource.hasToken();
      return Right(hasToken);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentUser() async {
    try {
      final userMap = await _localDataSource.getUser();
      if (userMap != null) {
        final authModel = AuthModel.fromJson(userMap);
        return Right(authModel.toEntity());
      }
      return const Right(null);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
