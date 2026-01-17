import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

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
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validation Methods
  bool _validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'البريد الإلكتروني مطلوب';
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      emailError.value = 'البريد الإلكتروني غير صحيح';
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
    if (password.length < minLength) {
      passwordError.value = 'كلمة المرور يجب أن تكون $minLength أحرف على الأقل';
      return false;
    }
    passwordError.value = null;
    return true;
  }

  bool _validateName() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      nameError.value = 'الاسم مطلوب';
      return false;
    }
    if (name.length < 3) {
      nameError.value = 'الاسم يجب أن يكون 3 أحرف على الأقل';
      return false;
    }
    nameError.value = null;
    return true;
  }

  bool _validateConfirmPassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'تأكيد كلمة المرور مطلوب';
      return false;
    }
    if (password != confirmPassword) {
      confirmPasswordError.value = 'كلمتا المرور غير متطابقتين';
      return false;
    }
    confirmPasswordError.value = null;
    return true;
  }

  // Login Method
  Future<void> login() async {
    // Clear previous errors
    emailError.value = null;
    passwordError.value = null;

    // Validate inputs
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();

    if (!isEmailValid || !isPasswordValid) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'نجح',
          result['message'] ?? 'تم تسجيل الدخول بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // Show error message
        String errorMessage = result['message'] ?? 'فشل تسجيل الدخول';
        
        // Handle specific field errors
        if (result['errors'] != null) {
          final errors = result['errors'] as Map<String, dynamic>;
          if (errors['email'] != null) {
            emailError.value = errors['email'][0];
          }
          if (errors['password'] != null) {
            passwordError.value = errors['password'][0];
          }
        }

        Get.snackbar(
          'خطأ',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Signup Method
  Future<void> signup() async {
    // Clear previous errors
    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    // Validate inputs
    final isNameValid = _validateName();
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword(minLength: 8);
    final isConfirmPasswordValid = _validateConfirmPassword();

    if (!isNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid) {
      return;
    }

    // Check terms acceptance
    if (!acceptTerms.value) {
      Get.snackbar(
        'تنبيه',
        'يجب الموافقة على الشروط والأحكام',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authService.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'نجح',
          result['message'] ?? 'تم إنشاء الحساب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // Show error message
        String errorMessage = result['message'] ?? 'فشل إنشاء الحساب';
        
        // Handle specific field errors
        if (result['errors'] != null) {
          final errors = result['errors'] as Map<String, dynamic>;
          if (errors['name'] != null) {
            nameError.value = errors['name'][0];
          }
          if (errors['email'] != null) {
            emailError.value = errors['email'][0];
          }
          if (errors['password'] != null) {
            passwordError.value = errors['password'][0];
          }
        }

        Get.snackbar(
          'خطأ',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _authService.isLoggedIn();
  }
}
