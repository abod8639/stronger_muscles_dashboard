import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_controller.dart';
import 'auth_state.dart';
import 'login_form_controller.dart';
import 'signup_form_controller.dart';

// Re-export centralized dioProvider for backward compatibility with sibling features
export 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';

/// ============================================================================
/// DATA LAYER PROVIDERS (Scoped & Lazily Evaluated)
/// ============================================================================

/// Provider for [AuthLocalDataSource] backed by [GetStorage].
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(storage: GetStorage());
});

/// Provider for [AuthRemoteDataSource] backed by centralized [dioProvider].
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

/// Provider for [AuthRepository] as the Single Source of Truth.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

/// ============================================================================
/// DOMAIN LAYER PROVIDERS (UseCases)
/// ============================================================================

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final checkAuthStatusUseCaseProvider = Provider<CheckAuthStatusUseCase>((ref) {
  return CheckAuthStatusUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// ============================================================================
/// PRESENTATION LAYER PROVIDERS (Controllers)
/// ============================================================================

/// State management controller for Authentication
final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Form controllers
final loginFormControllerProvider =
    NotifierProvider<LoginFormController, LoginFormState>(
  LoginFormController.new,
);

final signupFormControllerProvider =
    NotifierProvider<SignupFormController, SignupFormState>(
  SignupFormController.new,
);
