import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/theme/app_design_tokens.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/controllers/users_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: SingleChildScrollView(
        padding: AppDesignTokens.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // قسم إدارة المشرفين والصلاحيات
            _buildSectionCard(
              context: context,
              title: 'إدارة المشرفين والصلاحيات',
              child: usersAsync.when(
                loading: () => const Padding(
                  padding: AppDesignTokens.paddingCard,
                  child: EnhancedLoadingWidget(
                    message: 'جاري تحميل المشرفين...',
                  ),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'خطأ في تحميل المستخدمين: $error',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
                data: (stats) {
                  final admins = stats.users
                      .where((user) => user.role.toLowerCase() == 'admin')
                      .toList();

                  if (admins.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('لا يوجد مسؤولين حالياً'),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: admins.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final admin = admins[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            admin.name.isNotEmpty
                                ? admin.name[0].toUpperCase()
                                : 'A',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          admin.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(admin.email ?? 'لا يوجد بريد'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: AppDesignTokens.borderRadiusSmall,
                          ),
                          child: Text(
                            admin.role.toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // قسم الحساب
            _buildSectionCard(
              context: context,
              title: 'الحساب',
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDesignTokens.borderRadiusMedium,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignTokens.borderRadiusCard,
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: AppDesignTokens.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تسجيل الخروج',
        message: 'هل أنت متأكد من رغبتك في تسجيل الخروج من لوحة التحكم؟',
        confirmText: 'تسجيل الخروج',
        confirmColor: Theme.of(context).colorScheme.error,
        icon: Icons.logout_rounded,
        onConfirm: () {
          Navigator.of(ctx).pop();
          ref.read(authControllerProvider.notifier).logout();
        },
      ),
    );
  }
}
