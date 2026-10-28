import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

/// Immutable state for the Authentication feature.
@immutable
class AuthState {
  final AuthStatus status;
  final AuthEntity? user;
  final Failure? failure;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.failure,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  const AuthState.loading({AuthEntity? user})
      : this(status: AuthStatus.loading, user: user);

  const AuthState.authenticated(AuthEntity user)
      : this(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  const AuthState.failure(Failure failure, {AuthEntity? user})
      : this(status: AuthStatus.failure, failure: failure, user: user);

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isFailure => status == AuthStatus.failure;
  String? get errorMessage => failure?.toMessage();

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? user,
    Failure? failure,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user == other.user &&
          failure == other.failure;

  @override
  int get hashCode => status.hashCode ^ user.hashCode ^ failure.hashCode;

  @override
  String toString() =>
      'AuthState(status: $status, user: ${user?.name}, failure: $failure)';
}
