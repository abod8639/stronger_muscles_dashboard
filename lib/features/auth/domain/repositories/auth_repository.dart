import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/auth_entity.dart';

/// 100% Pure Dart Abstract Repository contract for Authentication.
/// Enforces functional error handling via `fpdart`'s `Either<Failure, T>`.
/// Contains zero imports from Flutter, Dio, or third-party storage libraries.
abstract class AuthRepository {
  /// Authenticates an administrator with email and password.
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  /// Registers a new administrator account.
  Future<Either<Failure, AuthEntity>> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Terminates the current session and purges cached authentication tokens.
  Future<Either<Failure, Unit>> logout();

  /// Checks whether an active authentication token exists locally.
  Future<Either<Failure, bool>> checkAuthStatus();

  /// Retrieves the currently cached administrator profile if available.
  Future<Either<Failure, AuthEntity?>> getCurrentUser();
}
