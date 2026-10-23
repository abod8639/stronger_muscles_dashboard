import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'auth_controller.dart';

/// موفر [Dio] الأساسي مع تعيين المهلات الزمنية وتمرير رمز المصادقة (Auth Interceptor)
final dioProvider = Provider<Dio>((ref) {
  final apiConfig = ApiConfigController();
  final dio = Dio(
    BaseOptions(
      baseUrl: apiConfig.baseUrl.value,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = AuthService.instance.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        final path = e.requestOptions.path;
        final isAuthEndpoint =
            path.contains('/login') || path.contains('/register');

        if (e.response?.statusCode == 401 && !isAuthEndpoint) {
          AuthService.instance.logout(sessionExpired: true);
        } else if (e.response?.statusCode == 403) {
          AppFeedback.showError('ليس لديك صلاحية للوصول إلى هذا المورد');
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});

/// موفر مصدر البيانات المحلي (GetStorage)
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(GetStorage());
});

/// موفر مصدر البيانات البعيد عبر الشبكة
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});

/// موفر مستودع المصادقة
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

/// موفرات حالات الاستخدام (UseCases)
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

/// موفر حالة المصادقة الرئيسي عبر [AsyncNotifier]
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthEntity?>(
  AuthController.new,
);
