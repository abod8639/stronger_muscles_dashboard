import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;

  AuthController({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
  });

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // States
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final acceptTerms = false.obs;

  // Error States
  final nameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool _validateLogin() {
    bool isValid = true;
    emailError.value = null;
    passwordError.value = null;

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'البريد الإلكتروني مطلوب';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'بريد إلكتروني غير صالح';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'كلمة المرور مطلوبة';
      isValid = false;
    }

    return isValid;
  }

  bool _validateSignup() {
    bool isValid = true;
    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'الاسم مطلوب';
      isValid = false;
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = 'البريد الإلكتروني مطلوب';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'بريد إلكتروني غير صالح';
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'كلمة المرور مطلوبة';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      isValid = false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'كلمات المرور غير متطابقة';
      isValid = false;
    }

    if (!acceptTerms.value) {
      Get.snackbar('تنبيه', 'يجب الموافقة على الشروط والأحكام');
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!_validateLogin()) return;

    try {
      isLoading.value = true;
      await loginUseCase(emailController.text.trim(), passwordController.text);
      
      Get.snackbar('نجاح', 'تم تسجيل الدخول بنجاح');
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('خطأ', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    if (!_validateSignup()) return;

    try {
      isLoading.value = true;
      await signupUseCase(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );
      
      Get.snackbar('نجاح', 'تم إنشاء الحساب بنجاح');
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('خطأ', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الخروج');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
