import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable state holding signup form fields and validation errors.
@immutable
class SignupFormState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool acceptTerms;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? termsError;

  const SignupFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.acceptTerms = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.termsError,
  });

  bool get isValid =>
      nameError == null &&
      emailError == null &&
      passwordError == null &&
      confirmPasswordError == null &&
      termsError == null;

  SignupFormState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? acceptTerms,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? termsError,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
    bool clearTermsError = false,
  }) {
    return SignupFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError
          ? null
          : (confirmPasswordError ?? this.confirmPasswordError),
      termsError: clearTermsError ? null : (termsError ?? this.termsError),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupFormState &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          confirmPassword == other.confirmPassword &&
          isPasswordVisible == other.isPasswordVisible &&
          isConfirmPasswordVisible == other.isConfirmPasswordVisible &&
          acceptTerms == other.acceptTerms &&
          nameError == other.nameError &&
          emailError == other.emailError &&
          passwordError == other.passwordError &&
          confirmPasswordError == other.confirmPasswordError &&
          termsError == other.termsError;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      confirmPassword.hashCode ^
      isPasswordVisible.hashCode ^
      isConfirmPasswordVisible.hashCode ^
      acceptTerms.hashCode ^
      nameError.hashCode ^
      emailError.hashCode ^
      passwordError.hashCode ^
      confirmPasswordError.hashCode ^
      termsError.hashCode;
}

/// Presentation Controller managing signup form input state and validation rules.
class SignupFormController extends Notifier<SignupFormState> {
  @override
  SignupFormState build() {
    return const SignupFormState();
  }

  void onNameChanged(String value) {
    state = state.copyWith(name: value, clearNameError: true);
  }

  void onEmailChanged(String value) {
    state = state.copyWith(email: value.trim(), clearEmailError: true);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value, clearPasswordError: true);
  }

  void onConfirmPasswordChanged(String value) {
    state = state.copyWith(
      confirmPassword: value,
      clearConfirmPasswordError: true,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void toggleAcceptTerms([bool? value]) {
    state = state.copyWith(
      acceptTerms: value ?? !state.acceptTerms,
      clearTermsError: true,
    );
  }

  /// Strictly validates input fields according to business rules.
  /// Returns true if valid, false otherwise.
  bool validate() {
    String? nameErr;
    String? emailErr;
    String? passwordErr;
    String? confirmErr;
    String? termsErr;

    if (state.name.trim().isEmpty) {
      nameErr = 'الاسم مطلوب';
    }

    final trimmedEmail = state.email.trim();
    if (trimmedEmail.isEmpty) {
      emailErr = 'البريد الإلكتروني مطلوب';
    } else if (!trimmedEmail.contains('@')) {
      emailErr = 'بريد إلكتروني غير صالح';
    }

    if (state.password.isEmpty) {
      passwordErr = 'كلمة المرور مطلوبة';
    } else if (state.password.length < 6) {
      passwordErr = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }

    if (state.confirmPassword != state.password) {
      confirmErr = 'كلمات المرور غير متطابقة';
    }

    if (!state.acceptTerms) {
      termsErr = 'يجب الموافقة على الشروط والأحكام للمتابعة';
    }

    state = state.copyWith(
      nameError: nameErr,
      emailError: emailErr,
      passwordError: passwordErr,
      confirmPasswordError: confirmErr,
      termsError: termsErr,
      clearNameError: nameErr == null,
      clearEmailError: emailErr == null,
      clearPasswordError: passwordErr == null,
      clearConfirmPasswordError: confirmErr == null,
      clearTermsError: termsErr == null,
    );

    return nameErr == null &&
        emailErr == null &&
        passwordErr == null &&
        confirmErr == null &&
        termsErr == null;
  }

  void reset() {
    state = const SignupFormState();
  }
}
