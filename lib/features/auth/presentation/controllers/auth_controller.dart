import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_entity.dart';
import 'auth_providers.dart';

class AuthController extends AsyncNotifier<AuthEntity?> {
  CancelToken? _cancelToken;

  @override
  FutureOr<AuthEntity?> build() {
    // إدارة الإلغاء عبر ref.onDispose لمنع تسريب الموارد أو الاستجابات المتأخرة
    ref.onDispose(() {
      _cancelToken?.cancel('تم إلغاء الطلب بسبب تفريغ الـ Notifier');
      _cancelToken = null;
    });

    final repo = ref.read(authRepositoryProvider);
    final result = repo.getCurrentUser();
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  /// تسجيل دخول المشرف مع إلغاء آمن لأي طلب نشط
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _cancelToken?.cancel('طلب تسجيل دخول جديد تم إرساله');
    _cancelToken = CancelToken();

    state = const AsyncLoading();

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      email.trim(),
      password,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  /// إنشاء حساب مشرف جديد
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _cancelToken?.cancel('طلب إنشاء حساب جديد تم إرساله');
    _cancelToken = CancelToken();

    state = const AsyncLoading();

    final signupUseCase = ref.read(signupUseCaseProvider);
    final result = await signupUseCase(
      name.trim(),
      email.trim(),
      password,
      cancelToken: _cancelToken,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    state = const AsyncLoading();
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    final result = await logoutUseCase();

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        state = const AsyncValue.data(null);
      },
    );
  }

  /// إعادة تعيين حالة الخطأ لاستعادة واجهة المستخدم الطبيعية
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value);
    }
  }
}
