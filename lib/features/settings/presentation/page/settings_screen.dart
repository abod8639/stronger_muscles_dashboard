import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/theme/app_design_tokens.dart';
import 'package:stronger_muscles_dashboard/features/auth/auth_feature.dart';
import 'package:stronger_muscles_dashboard/features/users/users_feature.dart';
import '../../domain/entities/settings_entity.dart';
import '../controllers/settings_providers.dart';

/// Production-ready, strictly isolated Settings presentation screen.
/// Adheres to Clean Architecture:
/// - Zero business or state mutation logic in UI
/// - Cross-feature communication only through public feature barrel files
/// - Selective state listening via Riverpod
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _storeNameController;
  late final TextEditingController _supportEmailController;
  late final TextEditingController _supportPhoneController;
  late final TextEditingController _currencyController;
  late final TextEditingController _deliveryFeeController;
  late final TextEditingController _freeDeliveryController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider).settings;
    _storeNameController = TextEditingController(text: settings.storeName);
    _supportEmailController = TextEditingController(text: settings.supportEmail);
    _supportPhoneController = TextEditingController(text: settings.supportPhone);
    _currencyController = TextEditingController(text: settings.currency);
    _deliveryFeeController =
        TextEditingController(text: settings.deliveryFee.toStringAsFixed(0));
    _freeDeliveryController = TextEditingController(
      text: settings.freeDeliveryThreshold.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _currencyController.dispose();
    _deliveryFeeController.dispose();
    _freeDeliveryController.dispose();
    super.dispose();
  }

  void _syncControllers(SettingsEntity settings) {
    if (_storeNameController.text != settings.storeName) {
      _storeNameController.text = settings.storeName;
    }
    if (_supportEmailController.text != settings.supportEmail) {
      _supportEmailController.text = settings.supportEmail;
    }
    if (_supportPhoneController.text != settings.supportPhone) {
      _supportPhoneController.text = settings.supportPhone;
    }
    if (_currencyController.text != settings.currency) {
      _currencyController.text = settings.currency;
    }
    final feeText = settings.deliveryFee.toStringAsFixed(0);
    if (_deliveryFeeController.text != feeText) {
      _deliveryFeeController.text = feeText;
    }
    final freeText = settings.freeDeliveryThreshold.toStringAsFixed(0);
    if (_freeDeliveryController.text != freeText) {
      _freeDeliveryController.text = freeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(settingsControllerProvider);
    final usersAsync = ref.watch(usersNotifierProvider);

    ref.listen(settingsControllerProvider.select((s) => s.settings), (_, next) {
      _syncControllers(next);
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('الإعدادات العامة ولوحة التحكم'),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(
              child: EnhancedLoadingWidget(
                message: 'جاري تحميل إعدادات المتجر...',
              ),
            )
          : SingleChildScrollView(
              padding: AppDesignTokens.paddingScreen,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. حالة المتجر والعمليات الأساسية
                      _buildStoreOperationsCard(context, state),
                      const SizedBox(height: 16),

                      // 2. بيانات المتجر والاتصال
                      _buildStoreDetailsCard(context, state),
                      const SizedBox(height: 16),

                      // 3. أداء النظام والتخزين المؤقت
                      _buildSystemMaintenanceCard(context, state),
                      const SizedBox(height: 16),

                      // 4. إدارة المشرفين والصلاحيات
                      _buildAdminsCard(context, usersAsync),
                      const SizedBox(height: 16),

                      // 5. جلسة العمل وتسجيل الخروج
                      _buildAccountSessionCard(context),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStoreOperationsCard(BuildContext context, dynamic state) {
    final settings = state.settings as SettingsEntity;
    final controller = ref.read(settingsControllerProvider.notifier);

    return _buildSectionCard(
      context: context,
      title: 'حالة المتجر والتشغيل المباشر',
      subtitle: 'التحكم الفوري في استقبال الطلبات وحالة الصيانة للعملاء',
      icon: Icons.storefront_rounded,
      child: Column(
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'استقبال الطلبات (المتجر مفتوح)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              settings.isStoreOpen
                  ? 'المتجر متاح حالياً ويستقبل طلبات العملاء بشكل طبيعي'
                  : 'المتجر مغلق وموقوف مؤقتاً عن استقبال طلبات جديدة',
            ),
            value: settings.isStoreOpen,
            onChanged: (val) => controller.toggleStoreOpen(val),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'وضع الصيانة للمتجر',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              settings.maintenanceMode
                  ? 'المتجر مغلق بشاشة صيانة ولن يتمكن الزبائن من التصفح'
                  : 'وضع الصيانة غير مفعل، المتجر يعمل بكفاءة',
            ),
            value: settings.maintenanceMode,
            onChanged: (val) => controller.toggleMaintenanceMode(val),
          ),
          const Divider(),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'تنبيهات الطلبات الجديدة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'إرسال إشعارات فورية للإدارة عند إنشاء طلبات شراء جديدة',
            ),
            value: settings.orderNotificationsEnabled,
            onChanged: (val) => controller.toggleOrderNotifications(val),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailsCard(BuildContext context, dynamic state) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final isSaving = state.isSaving as bool;

    return _buildSectionCard(
      context: context,
      title: 'بيانات المتجر والسياسة المالية',
      subtitle: 'اسم المتجر، قنوات الدعم، العملة، ورسوم الشحن والتوصيل',
      icon: Icons.business_center_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _storeNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المتجر',
                    prefixIcon: Icon(Icons.store_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _currencyController,
                  decoration: const InputDecoration(
                    labelText: 'رمز العملة الافتراضية',
                    prefixIcon: Icon(Icons.monetization_on_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _supportEmailController,
                  decoration: const InputDecoration(
                    labelText: 'بريد الدعم الفني',
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _supportPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'هاتف الدعم الفني',
                    prefixIcon: Icon(Icons.phone_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _deliveryFeeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'رسوم التوصيل القياسية',
                    prefixIcon: Icon(Icons.local_shipping_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: _freeDeliveryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'حد الشحن المجاني للطلب',
                    prefixIcon: Icon(Icons.card_giftcard_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: isSaving
                  ? null
                  : () {
                      final updated = (state.settings as SettingsEntity).copyWith(
                        storeName: _storeNameController.text.trim(),
                        supportEmail: _supportEmailController.text.trim(),
                        supportPhone: _supportPhoneController.text.trim(),
                        currency: _currencyController.text.trim(),
                        deliveryFee:
                            double.tryParse(_deliveryFeeController.text.trim()) ??
                                5000.0,
                        freeDeliveryThreshold: double.tryParse(
                                _freeDeliveryController.text.trim()) ??
                            100000.0,
                      );
                      controller.saveSettings(updated);
                    },
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_rounded),
              label: const Text('حفظ التعديلات'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMaintenanceCard(BuildContext context, dynamic state) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final isClearing = state.isClearingCache as bool;

    return _buildSectionCard(
      context: context,
      title: 'صيانة النظام والتخزين المؤقت',
      subtitle: 'إعادة ضبط ذاكرة التخزين المؤقت للبيانات وتحديث التطبيق',
      icon: Icons.cleaning_services_rounded,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفريغ الذاكرة المؤقتة (Clear Cache)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'مسح البيانات المؤقتة المحلية (Hive) لإجبار لوحة التحكم على جلب أحدث البيانات فوراً من الخادم.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: isClearing ? null : () => controller.clearCache(),
            icon: isClearing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_sweep_rounded),
            label: const Text('تفريغ الكاش'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminsCard(BuildContext context, dynamic usersAsync) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context: context,
      title: 'إدارة المشرفين والصلاحيات',
      subtitle: 'قائمة الحسابات الإدارية المصرح لها بإدارة لوحة التحكم',
      icon: Icons.admin_panel_settings_rounded,
      child: usersAsync.when(
        loading: () => const Padding(
          padding: AppDesignTokens.paddingCard,
          child: EnhancedLoadingWidget(
            message: 'جاري تحميل قائمة المشرفين...',
          ),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'خطأ في تحميل قائمة المستخدمين: $error',
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
              child: Text('لا يوجد مسؤولين مسجلين حالياً'),
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
                    alpha: 0.12,
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
                subtitle: Text(admin.email ?? 'لا يوجد بريد إلكتروني مسجل'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
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
    );
  }

  Widget _buildAccountSessionCard(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context: context,
      title: 'جلسة العمل والحساب',
      subtitle: 'إنهاء الجلسة الإدارية الحالية وتسجيل الخروج بأمان',
      icon: Icons.account_circle_rounded,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showLogoutDialog(context),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('تسجيل الخروج من لوحة التحكم'),
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
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    IconData? icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignTokens.borderRadiusCard,
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: AppDesignTokens.paddingCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.colorScheme.primary, size: 22),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
