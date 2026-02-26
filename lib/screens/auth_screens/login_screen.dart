import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/auth_screens/signup_screen.dart';
import 'package:stronger_muscles_dashboard/screens/auth_screens/widgets/build_primary_button.dart';
import 'package:stronger_muscles_dashboard/screens/auth_screens/widgets/build_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import '../../config/theme.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.find() بدلاً من Get.put() لاسترجاع AuthController المسجل
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية متدرجة فخمة
          _buildAnimatedBackground(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 0 : 24,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: _buildLoginCard(controller),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            const Color(0xFF4F46E5), // Indigo touch
            AppColors.primaryDark,
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard(AuthController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassContainer(
        borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.all(32),
        opacity: 0.08,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(height: 24),
            _buildHeaderText(),
            const SizedBox(height: 40),
            _buildFormFields(controller),
            const SizedBox(height: 16),
            _buildRememberForgot(controller),
            const SizedBox(height: 32),
            _buildLoginAction(controller),
            const SizedBox(height: 24),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.fitness_center_rounded,
        size: 55,
        color: Colors.white,
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        const Text(
          'تسجيل الدخول',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'مرحباً بك في لوحة تحكم Stronger Muscles',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(AuthController controller) {
    return Column(
      children: [
        Obx(
          () => buildTextField(
            controller: controller.emailController,
            label: 'البريد الإلكتروني',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            errorText: controller.emailError.value,
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => buildTextField(
            controller: controller.passwordController,
            label: 'كلمة المرور',
            icon: Icons.lock_person_outlined,
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible.value,
            onTogglePassword: controller.togglePasswordVisibility,
            errorText: controller.passwordError.value,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgot(AuthController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => InkWell(
            onTap: () => controller.rememberMe.toggle(),
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (v) => controller.rememberMe.value = v!,
                    activeColor: AppColors.primary,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'تذكرني',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginAction(AuthController controller) {
    return Obx(
      () => buildPrimaryButton(
        label: 'تسجيل الدخول',
        isLoading: controller.isLoading.value,
        onPressed: controller.login,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () => Get.to(
            () => const SignupScreen(),
            transition: Transition.cupertino,
          ),
          child: const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
