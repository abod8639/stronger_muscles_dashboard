import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/update_admin_ai_config_usecase.dart';
import 'auth_state.dart';

/// Presentation Controller managing authentication state.
/// Pure functional error handling: uses `Either<Failure, T>.fold(...)` with ZERO try-catch blocks.
/// 100% testable with Constructor Dependency Injection for unit tests.
class AuthController extends Notifier<AuthState> {
  final LoginUseCase? _injectedLoginUseCase;
  final SignupUseCase? _injectedSignupUseCase;
  final LogoutUseCase? _injectedLogoutUseCase;
  final GetCurrentUserUseCase? _injectedGetCurrentUserUseCase;
  final CheckAuthStatusUseCase? _injectedCheckAuthStatusUseCase;
  final UpdateAdminAiConfigUseCase? _injectedUpdateAdminAiConfigUseCase;

  AuthController({
    LoginUseCase? loginUseCase,
    SignupUseCase? signupUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
    CheckAuthStatusUseCase? checkAuthStatusUseCase,
    UpdateAdminAiConfigUseCase? updateAdminAiConfigUseCase,
  }) : _injectedLoginUseCase = loginUseCase,
       _injectedSignupUseCase = signupUseCase,
       _injectedLogoutUseCase = logoutUseCase,
       _injectedGetCurrentUserUseCase = getCurrentUserUseCase,
       _injectedCheckAuthStatusUseCase = checkAuthStatusUseCase,
       _injectedUpdateAdminAiConfigUseCase = updateAdminAiConfigUseCase;

  LoginUseCase get _loginUseCase =>
      _injectedLoginUseCase ?? ref.read(loginUseCaseProvider);

  SignupUseCase get _signupUseCase =>
      _injectedSignupUseCase ?? ref.read(signupUseCaseProvider);

  LogoutUseCase get _logoutUseCase =>
      _injectedLogoutUseCase ?? ref.read(logoutUseCaseProvider);

  GetCurrentUserUseCase get _getCurrentUserUseCase =>
      _injectedGetCurrentUserUseCase ?? ref.read(getCurrentUserUseCaseProvider);

  CheckAuthStatusUseCase get _checkAuthStatusUseCase =>
      _injectedCheckAuthStatusUseCase ??
      ref.read(checkAuthStatusUseCaseProvider);

  UpdateAdminAiConfigUseCase get _updateAdminAiConfigUseCase =>
      _injectedUpdateAdminAiConfigUseCase ??
      ref.read(updateAdminAiConfigUseCaseProvider);

  @override
  AuthState build() {
    _initSession();
    return const AuthState.initial();
  }

  /// Restores session from local cache on initialization
  Future<void> _initSession() async {
    final statusResult = await _checkAuthStatusUseCase();
    statusResult.fold((failure) => state = const AuthState.unauthenticated(), (
      hasToken,
    ) async {
      if (!hasToken) {
        state = const AuthState.unauthenticated();
        return;
      }

      final userResult = await _getCurrentUserUseCase();
      userResult.fold((failure) => state = const AuthState.unauthenticated(), (
        user,
      ) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      });
    });
  }

  /// Administrator login action
  Future<bool> login({required String email, required String password}) async {
    state = AuthState.loading(user: state.user);

    final result = await _loginUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        state = AuthState.failure(failure);
        return false;
      },
      (user) {
        state = AuthState.authenticated(user);
        return true;
      },
    );
  }

  /// Administrator registration action
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AuthState.loading(user: state.user);

    final result = await _signupUseCase(
      name: name,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = AuthState.failure(failure);
        return false;
      },
      (user) {
        state = AuthState.authenticated(user);
        return true;
      },
    );
  }

  /// Session termination action
  Future<void> logout() async {
    state = AuthState.loading(user: state.user);

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        state = AuthState.failure(failure, user: state.user);
      },
      (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }

  /// Clears active failure state to restore clean UI view
  void clearError() {
    if (state.isFailure) {
      state = state.user != null
          ? AuthState.authenticated(state.user!)
          : const AuthState.unauthenticated();
    }
  }

  /// Directly sets the authenticated user if needed
  void setAuthenticatedUser(AuthEntity user) {
    state = AuthState.authenticated(user);
  }

  /// Updates the administrator's Gemini AI configuration in the remote database and local storage.
  Future<bool> updateAiConfig({
    required String apiKey,
    required String model,
  }) async {
    final result = await _updateAdminAiConfigUseCase(
      apiKey: apiKey,
      model: model,
    );

    return result.fold(
      (failure) {
        return false;
      },
      (updatedUser) {
        state = AuthState.authenticated(updatedUser);
        return true;
      },
    );
  }
}
