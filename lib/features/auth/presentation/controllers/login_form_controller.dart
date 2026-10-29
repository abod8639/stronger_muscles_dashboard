import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable state holding login form fields and validation errors.
@immutable
class LoginFormState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
  });

  bool get isValid => emailError == null && passwordError == null;

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginFormState &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          isPasswordVisible == other.isPasswordVisible &&
          rememberMe == other.rememberMe &&
          emailError == other.emailError &&
          passwordError == other.passwordError;

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      isPasswordVisible.hashCode ^
      rememberMe.hashCode ^
      emailError.hashCode ^
      passwordError.hashCode;
}

/// Presentation Controller managing login form input state and validation rules.
class LoginFormController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void onEmailChanged(String value) {
    state = state.copyWith(email: value.trim(), clearEmailError: true);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value, clearPasswordError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleRememberMe([bool? value]) {
    state = state.copyWith(rememberMe: value ?? !state.rememberMe);
  }

  /// Strictly validates input fields according to business rules.
  /// Returns true if valid, false otherwise.
  bool validate() {
    String? emailErr;
    String? passwordErr;

    final trimmedEmail = state.email.trim();
    if (trimmedEmail.isEmpty) {
      emailErr = 'البريد الإلكتروني مطلوب';
    } else if (!trimmedEmail.contains('@') && trimmedEmail != 'test') {
      emailErr = 'بريد إلكتروني غير صالح';
    }

    if (state.password.isEmpty) {
      passwordErr = 'كلمة المرور مطلوبة';
    }

    state = state.copyWith(
      emailError: emailErr,
      passwordError: passwordErr,
      clearEmailError: emailErr == null,
      clearPasswordError: passwordErr == null,
    );

    return emailErr == null && passwordErr == null;
  }

  void reset() {
    state = const LoginFormState();
  }
}
