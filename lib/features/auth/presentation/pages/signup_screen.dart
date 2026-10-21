import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/features/auth/domain/entities/auth_entity.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_primary_button.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'الاسم مطلوب');
      isValid = false;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'البريد الإلكتروني مطلوب');
      isValid = false;
    } else if (!email.contains('@')) {
      setState(() => _emailError = 'بريد إلكتروني غير صالح');
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'كلمة المرور مطلوبة');
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      isValid = false;
    }

    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'كلمات المرور غير متطابقة');
      isValid = false;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الشروط والأحكام للمتابعة'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleSignup() async {
    if (!_validate()) return;

    final success = await ref.read(authControllerProvider.notifier).signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      Get.offAllNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    // الاستماع للتغييرات
    ref.listen<AsyncValue<AuthEntity?>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message =
              error is Failure ? error.toMessage() : error.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        data: (user) {
          if (user != null && previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 10),
                    Text('تم إنشاء الحساب بنجاح'),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 0 : 24,
                  vertical: 24,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 450 : double.infinity,
                  ),
                  child: TweenAnimationBuilder<double>(
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
                          const SizedBox(height: 28),

                          // واجهة بديلة (Fallback UI) عند حدوث خطأ دون انهيار الشاشة
                          if (authState.hasError && authState.error != null)
                            AuthErrorCard(
                              error: authState.error!,
                              onRetry: _handleSignup,
                              onDismiss: () => ref
                                  .read(authControllerProvider.notifier)
                                  .clearError(),
                            ),

                          // Form
                          _buildFormFields(authState.isLoading),
                          const SizedBox(height: 20),

                          // Terms and Conditions
                          _buildTerms(authState.isLoading),
                          const SizedBox(height: 32),

                          // Submit Button
                          buildPrimaryButton(
                            label: 'إنشاء الحساب',
                            isLoading: authState.isLoading,
                            onPressed: _handleSignup,
                          ),
                          const SizedBox(height: 24),

                          // Footer
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(bool isLoading) {
    return Column(
      children: [
        buildTextField(
          controller: _nameController,
          label: 'الاسم الكامل',
          icon: Icons.person_outline,
          errorText: _nameError,
        ),
        const SizedBox(height: 16),
        buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
        ),
        const SizedBox(height: 16),
        buildTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: _isPasswordVisible,
          onTogglePassword: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
          errorText: _passwordError,
        ),
        const SizedBox(height: 16),
        buildTextField(
          controller: _confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: _isConfirmPasswordVisible,
          onTogglePassword: () => setState(
              () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          errorText: _confirmPasswordError,
        ),
      ],
    );
  }

  Widget _buildTerms(bool isLoading) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _acceptTerms,
            onChanged: isLoading
                ? null
                : (value) => setState(() => _acceptTerms = value ?? false),
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
        Expanded(
          child: Wrap(
            children: [
              Text(
                'أوافق على ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'الشروط والأحكام',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                ' و ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'سياسة الخصوصية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
