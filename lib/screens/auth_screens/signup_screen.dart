import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/auth_screens/widgets/build_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/auth_screens/widgets/build_primary_button.dart';
import '../../config/theme.dart';
import '../../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      body:  SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : 24,
                vertical: 24,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 450 : double.infinity,
                ),
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_add_outlined,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'انضم إلى فريق Stronger Muscles',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Name Field
                        Obx(
                          () => buildTextField(
                            controller: controller.nameController,
                            label: 'الاسم الكامل',
                            icon: Icons.person_outline,
                            errorText: controller.nameError.value,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        Obx(
                          () => buildTextField(
                            controller: controller.emailController,
                            label: 'البريد الإلكتروني',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            errorText: controller.emailError.value,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Obx(
                          () => buildTextField(
                            controller: controller.passwordController,
                            label: 'كلمة المرور',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible:
                                controller.isPasswordVisible.value,
                            onTogglePassword:
                                controller.togglePasswordVisibility,
                            errorText: controller.passwordError.value,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        Obx(
                          () => buildTextField(
                            controller: controller.confirmPasswordController,
                            label: 'تأكيد كلمة المرور',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible:
                                controller.isConfirmPasswordVisible.value,
                            onTogglePassword:
                                controller.toggleConfirmPasswordVisibility,
                            errorText: controller.confirmPasswordError.value,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Terms and Conditions
                        Obx(
                          () => Row(
                            children: [
                              Checkbox(
                                value: controller.acceptTerms.value,
                                onChanged: (value) {
                                  controller.acceptTerms.value = value ?? false;
                                },
                                fillColor: WidgetStateProperty.all(
                                  Colors.white.withValues(alpha: 0.3),
                                ),
                                checkColor: AppColors.primary,
                              ),
                              Expanded(
                                child: Text(
                                  'أوافق على الشروط والأحكام',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Signup Button
                        Obx(
                          () => buildPrimaryButton(
                            label: 'إنشاء الحساب',
                            isLoading: controller.isLoading.value,
                            onPressed: controller.signup,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لديك حساب بالفعل؟ ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}
