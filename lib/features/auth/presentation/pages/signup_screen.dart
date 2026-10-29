import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/build_background.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_error_card.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

/// Strictly Dumb UI Screen for Signup.
/// Contains ZERO business or validation logic.
/// Uses selective state listening via `.select()` to prevent unnecessary widget rebuilds.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Delegate validation entirely to form controller
    final isValid = ref.read(signupFormControllerProvider.notifier).validate();
    if (!isValid) return;

    final formState = ref.read(signupFormControllerProvider);
    final success = await ref
        .read(authControllerProvider.notifier)
        .signup(
          name: formState.name,
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
                          const _SignupHeader(),
                          const SizedBox(height: 28),
                          const _SignupErrorSection(),
                          _buildFormInputs(),
                          const SizedBox(height: 20),
                          const _SignupTermsSection(),
                          const SizedBox(height: 32),
                          _SignupActionButton(onSignup: _handleSignup),
                          const SizedBox(height: 24),
                          const _SignupFooter(),
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

  Widget _buildFormInputs() {
    return Column(
      children: [
        // Name field with selective rebuild
        Consumer(
          builder: (context, ref, child) {
            final nameError = ref.watch(
              signupFormControllerProvider.select((s) => s.nameError),
            );
            return AuthTextField(
              controller: _nameController,
              label: 'الاسم الكامل',
              icon: Icons.person_outline,
              errorText: nameError,
              onChanged: (val) => ref
                  .read(signupFormControllerProvider.notifier)
                  .onNameChanged(val),
            );
          },
        ),
        const SizedBox(height: 16),
        // Email field with selective rebuild
        Consumer(
          builder: (context, ref, child) {
            final emailError = ref.watch(
              signupFormControllerProvider.select((s) => s.emailError),
            );
            return AuthTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              errorText: emailError,
              onChanged: (val) => ref
                  .read(signupFormControllerProvider.notifier)
                  .onEmailChanged(val),
            );
          },
        ),
        const SizedBox(height: 16),
        // Password field with selective rebuild
        Consumer(
          builder: (context, ref, child) {
            final isVisible = ref.watch(
              signupFormControllerProvider.select((s) => s.isPasswordVisible),
            );
            final passwordError = ref.watch(
              signupFormControllerProvider.select((s) => s.passwordError),
            );
            return AuthTextField(
              controller: _passwordController,
              label: 'كلمة المرور',
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: isVisible,
              errorText: passwordError,
              onTogglePassword: () => ref
                  .read(signupFormControllerProvider.notifier)
                  .togglePasswordVisibility(),
              onChanged: (val) => ref
                  .read(signupFormControllerProvider.notifier)
                  .onPasswordChanged(val),
            );
          },
        ),
        const SizedBox(height: 16),
        // Confirm Password field with selective rebuild
        Consumer(
          builder: (context, ref, child) {
            final isVisible = ref.watch(
              signupFormControllerProvider.select(
                (s) => s.isConfirmPasswordVisible,
              ),
            );
            final confirmError = ref.watch(
              signupFormControllerProvider.select(
                (s) => s.confirmPasswordError,
              ),
            );
            return AuthTextField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور',
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: isVisible,
              errorText: confirmError,
              onTogglePassword: () => ref
                  .read(signupFormControllerProvider.notifier)
                  .toggleConfirmPasswordVisibility(),
              onChanged: (val) => ref
                  .read(signupFormControllerProvider.notifier)
                  .onConfirmPasswordChanged(val),
            );
          },
        ),
      ],
    );
  }
}

/// Dumb Signup Header (const constructor)
class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}

/// Selective error card
class _SignupErrorSection extends ConsumerWidget {
  const _SignupErrorSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = ref.watch(authControllerProvider.select((s) => s.failure));

    if (failure == null) return const SizedBox.shrink();

    return AuthErrorCard(
      error: failure,
      onDismiss: () => ref.read(authControllerProvider.notifier).clearError(),
    );
  }
}

/// Selective terms and conditions check
class _SignupTermsSection extends ConsumerWidget {
  const _SignupTermsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptTerms = ref.watch(
      signupFormControllerProvider.select((s) => s.acceptTerms),
    );
    final termsError = ref.watch(
      signupFormControllerProvider.select((s) => s.termsError),
    );
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: acceptTerms,
                onChanged: isLoading
                    ? null
                    : (v) => ref
                          .read(signupFormControllerProvider.notifier)
                          .toggleAcceptTerms(v),
                activeColor: AppColors.primary,
                side: BorderSide(
                  color: termsError != null
                      ? AppColors.error
                      : Colors.white.withValues(alpha: 0.4),
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
        ),
        if (termsError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 32),
            child: Text(
              termsError,
              style: const TextStyle(color: AppColors.error, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

/// Action button with selective rebuild
class _SignupActionButton extends ConsumerWidget {
  final VoidCallback onSignup;

  const _SignupActionButton({required this.onSignup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return AuthPrimaryButton(
      label: 'إنشاء الحساب',
      isLoading: isLoading,
      onPressed: onSignup,
    );
  }
}

/// Static footer
class _SignupFooter extends StatelessWidget {
  const _SignupFooter();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
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
