import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;

  AuthController({required this.loginUseCase});

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // States
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال جميع البيانات');
      return;
    }

    try {
      isLoading.value = true;
      await loginUseCase(email, password);
      
      Get.snackbar('نجاح', 'تم تسجيل الدخول بنجاح');
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
