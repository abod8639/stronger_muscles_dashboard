import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/features/auth/domain/entities/auth_entity.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_primary_button.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/build_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'البريد الإلكتروني مطلوب');
      isValid = false;
    } else if (!email.contains('@') && email != 'test') {
      setState(() => _emailError = 'بريد إلكتروني غير صالح');
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'كلمة المرور مطلوبة');
      isValid = false;
    }

    return isValid;
  }

  Future<void> _handleLogin() async {
    if (!_validate()) return;

    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    // الاستماع لتغييرات الحالة لعرض الرسائل وتأثيرات التنقل
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
                    Text('تم تسجيل الدخول بنجاح'),
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: _buildLoginCard(authState),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(AsyncValue<AuthEntity?> authState) {
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
            const SizedBox(height: 28),

            // واجهة بديلة (Fallback UI) عند حدوث خطأ دون انهيار الشاشة
            if (authState.hasError && authState.error != null)
              AuthErrorCard(
                error: authState.error!,
                onRetry: _handleLogin,
                onDismiss: () =>
                    ref.read(authControllerProvider.notifier).clearError(),
              ),

            _buildFormFields(authState.isLoading),
            const SizedBox(height: 16),
            _buildRememberForgot(authState.isLoading),
            const SizedBox(height: 32),
            _buildLoginAction(authState.isLoading),
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

  Widget _buildFormFields(bool isLoading) {
    return Column(
      children: [
        buildTextField(
          controller: _emailController,
          label: 'اسم المستخدم (test) / البريد الإلكتروني',
          icon: Icons.person_outline,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
        ),
        const SizedBox(height: 20),
        buildTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          icon: Icons.lock_person_outlined,
          isPassword: true,
          isPasswordVisible: _isPasswordVisible,
          onTogglePassword: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
          errorText: _passwordError,
        ),
      ],
    );
  }

  Widget _buildRememberForgot(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: isLoading
              ? null
              : () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: isLoading
                      ? null
                      : (v) => setState(() => _rememberMe = v ?? false),
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

  Widget _buildLoginAction(bool isLoading) {
    return buildPrimaryButton(
      label: 'تسجيل الدخول',
      isLoading: isLoading,
      onPressed: _handleLogin,
    );
  }

  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.signup),
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
