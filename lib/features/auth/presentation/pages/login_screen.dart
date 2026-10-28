import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_error_card.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

/// Strictly Dumb UI Screen for Login.
/// Contains ZERO business or validation logic.
/// Uses selective state listening via `.select()` to prevent unnecessary widget rebuilds.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Delegate validation entirely to form controller
    final isValid = ref.read(loginFormControllerProvider.notifier).validate();
    if (!isValid) return;

    final formState = ref.read(loginFormControllerProvider);
    final success = await ref.read(authControllerProvider.notifier).login(
          email: formState.email,
          password: formState.password,
        );

    if (success && mounted) {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    // Side-effects listener: SnackBar feedback for errors & success
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.isFailure && next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(next.failure!.toMessage())),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else if (next.isAuthenticated && previous?.isLoading == true) {
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
                    child: _buildLoginCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
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
            const _LoginHeader(),
            const SizedBox(height: 28),
            const _LoginErrorSection(),
            _buildFormInputs(),
            const SizedBox(height: 16),
            const _LoginRememberForgotSection(),
            const SizedBox(height: 32),
            _LoginActionButton(onLogin: _handleLogin),
            const SizedBox(height: 24),
            const _LoginFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormInputs() {
    return Column(
      children: [
        // Selective listening for email error only
        Consumer(
          builder: (context, ref, child) {
            final emailError = ref.watch(
              loginFormControllerProvider.select((s) => s.emailError),
            );
            return AuthTextField(
              controller: _emailController,
              label: 'اسم المستخدم (test) / البريد الإلكتروني',
              icon: Icons.person_outline,
              keyboardType: TextInputType.emailAddress,
              errorText: emailError,
              onChanged: (val) => ref
                  .read(loginFormControllerProvider.notifier)
                  .onEmailChanged(val),
            );
          },
        ),
        const SizedBox(height: 20),
        // Selective listening for password error & visibility only
        Consumer(
          builder: (context, ref, child) {
            final isVisible = ref.watch(
              loginFormControllerProvider.select((s) => s.isPasswordVisible),
            );
            final passwordError = ref.watch(
              loginFormControllerProvider.select((s) => s.passwordError),
            );
            return AuthTextField(
              controller: _passwordController,
              label: 'كلمة المرور',
              icon: Icons.lock_person_outlined,
              isPassword: true,
              isPasswordVisible: isVisible,
              errorText: passwordError,
              onTogglePassword: () => ref
                  .read(loginFormControllerProvider.notifier)
                  .togglePasswordVisibility(),
              onChanged: (val) => ref
                  .read(loginFormControllerProvider.notifier)
                  .onPasswordChanged(val),
            );
          },
        ),
      ],
    );
  }
}

/// Dumb Header Widget (const constructor)
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
        ),
        const SizedBox(height: 24),
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
}

/// Selective error display
class _LoginErrorSection extends ConsumerWidget {
  const _LoginErrorSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = ref.watch(
      authControllerProvider.select((s) => s.failure),
    );

    if (failure == null) return const SizedBox.shrink();

    return AuthErrorCard(
      error: failure,
      onDismiss: () => ref.read(authControllerProvider.notifier).clearError(),
    );
  }
}

/// Selective Remember Me & Forgot Password Section
class _LoginRememberForgotSection extends ConsumerWidget {
  const _LoginRememberForgotSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rememberMe = ref.watch(
      loginFormControllerProvider.select((s) => s.rememberMe),
    );
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: isLoading
              ? null
              : () => ref
                  .read(loginFormControllerProvider.notifier)
                  .toggleRememberMe(),
          child: Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: rememberMe,
                  onChanged: isLoading
                      ? null
                      : (v) => ref
                          .read(loginFormControllerProvider.notifier)
                          .toggleRememberMe(v),
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
}

/// Action button with selective rebuild on loading state
class _LoginActionButton extends ConsumerWidget {
  final VoidCallback onLogin;

  const _LoginActionButton({required this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return AuthPrimaryButton(
      label: 'تسجيل الدخول',
      isLoading: isLoading,
      onPressed: onLogin,
    );
  }
}

/// Static footer widget
class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
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
