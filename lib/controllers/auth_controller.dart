import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';

class AuthController extends GetxController {
  // Using the unified ApiService bridge which handles auth logic for legacy code
  final ApiService _apiService = Get.find<ApiService>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable States
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final acceptTerms = false.obs;

  // Error Messages
  final emailError = RxnString();
  final passwordError = RxnString();
  final nameError = RxnString();
  final confirmPasswordError = RxnString();

  @override
  void onInit() {
    emailController.text = '';
    passwordController.text = '';
    nameController.text = '';
    confirmPasswordController.text = '';
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'البريد الإلكتروني أو اسم المستخدم مطلوب';
      return false;
    }
    if (email != 'test' && !GetUtils.isEmail(email)) {
      emailError.value = 'يرجى إدخال اسم مستخدم صحيح أو بريد إلكتروني';
      return false;
    }
    emailError.value = null;
    return true;
  }

  bool _validatePassword({int minLength = 6}) {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = 'كلمة المرور مطلوبة';
      return false;
    }
    if (password != 'test' && password.length < minLength) {
      passwordError.value = 'كلمة المرور يجب أن تكون $minLength أحرف على الأقل';
      return false;
    }
    passwordError.value = null;
    return true;
  }

  Future<void> login() async {
    emailError.value = null;
    passwordError.value = null;

    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();

    if (!isEmailValid || !isPasswordValid) return;

    isLoading.value = true;

    // Admin test mode logic
    if (emailController.text.trim() == 'test' && passwordController.text == 'test') {
      await Future.delayed(const Duration(milliseconds: 800));
      Get.offAllNamed('/dashboard');
      isLoading.value = false;
      return;
    }

    // In a real scenario, login logic would be in AuthRemoteDataSource
    // For now, we keep it simple or delegate to specific feature logic
    isLoading.value = false;
    Get.offAllNamed('/dashboard');
  }

  Future<void> logout() async {
    // Logic handled by ApiBase interceptor if 401 occurs, 
    // or manually clear tokens here
    Get.offAllNamed('/login');
  }
}
