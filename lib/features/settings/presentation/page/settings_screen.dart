import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_fields_row.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/auth/auth_feature.dart';
import 'package:stronger_muscles_dashboard/features/users/users_feature.dart';
import '../../domain/entities/settings_entity.dart';
import '../controllers/settings_providers.dart';
import '../controllers/settings_state.dart';

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
  late final TextEditingController _taxRateController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider).settings;
    _storeNameController = TextEditingController(text: settings.storeName);
    _supportEmailController = TextEditingController(
      text: settings.supportEmail,
    );
    _supportPhoneController = TextEditingController(
      text: settings.supportPhone,
    );
    _currencyController = TextEditingController(text: settings.currency);
    _deliveryFeeController = TextEditingController(
      text: _formatAmount(settings.deliveryFee),
    );
    _freeDeliveryController = TextEditingController(
      text: _formatAmount(settings.freeDeliveryThreshold),
    );
    _taxRateController = TextEditingController(
      text: _formatAmount(settings.taxRate),
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
    _taxRateController.dispose();
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
    final feeText = _formatAmount(settings.deliveryFee);
    if (_deliveryFeeController.text != feeText) {
      _deliveryFeeController.text = feeText;
    }
    final freeText = _formatAmount(settings.freeDeliveryThreshold);
    if (_freeDeliveryController.text != freeText) {
      _freeDeliveryController.text = freeText;
    }
    final taxText = _formatAmount(settings.taxRate);
    if (_taxRateController.text != taxText) {
      _taxRateController.text = taxText;
    }
  }

  /// Shows whole amounts without decimals but keeps fractions (e.g. 12.5)
  /// so saving the form never rounds a value the admin did not change.
  static String _formatAmount(double value) {
    return value == value.truncateToDouble()
        ? value.toStringAsFixed(0)
        : value.toString();
  }

  /// Parses a non-negative number from [text], keeping [fallback] when the
  /// field is empty or invalid instead of silently saving a default.
  static double _parseAmount(String text, double fallback, {double? max}) {
    final value = double.tryParse(text.trim().replaceAll(',', '.'));
    if (value == null || value < 0 || (max != null && value > max)) {
      return fallback;
    }
    return value;
  }

  void _refresh() {
    ref.read(settingsControllerProvider.notifier).fetchSettings();
    ref.read(usersNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);
    final usersAsync = ref.watch(usersNotifierProvider);
    final responsive = context.responsive;
    final hasSettings = state.settings.storeName.isNotEmpty;

    ref.listen(settingsControllerProvider.select((s) => s.settings), (_, next) {
      _syncControllers(next);
    });

    ref.listen(settingsControllerProvider.select((s) => s.errorMessage), (
      _,
      next,
    ) {
      if (next != null && context.mounted) {
        AppFeedback.showError(next);
      }
    });

    ref.listen(settingsControllerProvider.select((s) => s.successMessage), (
      _,
      next,
    ) {
      if (next != null && context.mounted) {
        AppFeedback.showSuccess(next);
      }
    });

    final Widget body;
    if (state.isLoading && !hasSettings) {
      body = const EnhancedLoadingWidget(
        message: 'جاري تحميل إعدادات المتجر...',
      );
    } else if (state.errorMessage != null && !hasSettings) {
      body = EnhancedErrorWidget(
        title: 'تعذر الاتصال بالخادم',
        message: state.errorMessage!,
        icon: Icons.cloud_off_rounded,
        onRetry: _refresh,
      );
    } else {
      final gap = SizedBox(height: responsive.itemSpacing * 1.5);
      body = Stack(
        children: [
          SingleChildScrollView(
            padding: responsive.defaultPadding,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStoreOperationsCard(state),
                    gap,
                    _buildStoreDetailsCard(state),
                    gap,
                    _buildSystemMaintenanceCard(state),
                    gap,
                    _buildAdminsCard(usersAsync),
                    gap,
                    _buildAccountSessionCard(),
                    const SizedBox(height: AppDesignTokens.space32),
                  ],
                ),
              ),
            ),
          ),
          // التحديث لا يخفي النموذج، بل يظهر شريط تقدم رفيع أعلى الصفحة
          if (state.isLoading)
            const PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(title: 'الإعدادات', onPressed: _refresh),
      body: body,
    );
  }

  Widget _buildStoreOperationsCard(SettingsState state) {
    final settings = state.settings;
    final controller = ref.read(settingsControllerProvider.notifier);

    return SectionCard(
      title: 'حالة المتجر والتشغيل المباشر',
      subtitle: 'التحكم الفوري في استقبال الطلبات وحالة الصيانة للعملاء',
      icon: Icons.storefront_rounded,
      child: DividedColumn(
        children: [
          _SettingSwitch(
            title: 'استقبال الطلبات (المتجر مفتوح)',
            subtitle: settings.isStoreOpen
                ? 'المتجر متاح حالياً ويستقبل طلبات العملاء بشكل طبيعي'
                : 'المتجر مغلق وموقوف مؤقتاً عن استقبال طلبات جديدة',
            value: settings.isStoreOpen,
            onChanged: controller.toggleStoreOpen,
          ),
          _SettingSwitch(
            title: 'وضع الصيانة للمتجر',
            subtitle: settings.maintenanceMode
                ? 'المتجر مغلق بشاشة صيانة ولن يتمكن الزبائن من التصفح'
                : 'وضع الصيانة غير مفعل، المتجر يعمل بكفاءة',
            value: settings.maintenanceMode,
            onChanged: controller.toggleMaintenanceMode,
          ),
          _SettingSwitch(
            title: 'تنبيهات الطلبات الجديدة',
            subtitle: 'إرسال إشعارات فورية للإدارة عند إنشاء طلبات شراء جديدة',
            value: settings.orderNotificationsEnabled,
            onChanged: controller.toggleOrderNotifications,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailsCard(SettingsState state) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final isSaving = state.isSaving;
    const gap = SizedBox(height: AppDesignTokens.space14);
    const decimal = TextInputType.numberWithOptions(decimal: true);

    return SectionCard(
      title: 'بيانات المتجر والسياسة المالية',
      subtitle: 'اسم المتجر، قنوات الدعم، العملة، رسوم التوصيل ونسبة الضريبة',
      icon: Icons.business_center_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResponsiveFieldsRow(
            children: [
              ModernTextField(
                controller: _storeNameController,
                label: 'اسم المتجر',
                icon: Icons.store_rounded,
              ),
              ModernTextField(
                controller: _currencyController,
                label: 'رمز العملة الافتراضية',
                helperText: 'يظهر بجانب كل الأسعار في لوحة التحكم',
                icon: Icons.monetization_on_rounded,
              ),
            ],
          ),
          gap,
          ResponsiveFieldsRow(
            children: [
              ModernTextField(
                controller: _supportEmailController,
                label: 'بريد الدعم الفني',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              ModernTextField(
                controller: _supportPhoneController,
                label: 'هاتف الدعم الفني',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          gap,
          ResponsiveFieldsRow(
            children: [
              ModernTextField(
                controller: _deliveryFeeController,
                label: 'رسوم التوصيل القياسية',
                icon: Icons.local_shipping_rounded,
                keyboardType: decimal,
              ),
              ModernTextField(
                controller: _freeDeliveryController,
                label: 'حد الشحن المجاني للطلب',
                helperText: '0 = بدون توصيل مجاني',
                icon: Icons.card_giftcard_rounded,
                keyboardType: decimal,
              ),
              ModernTextField(
                controller: _taxRateController,
                label: 'نسبة الضريبة',
                helperText: 'تُحسب على سعر المنتجات، 0 = بدون ضريبة',
                suffixText: '%',
                icon: Icons.percent_rounded,
                keyboardType: decimal,
              ),
            ],
          ),
          const SizedBox(height: AppDesignTokens.space18),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.icon(
              onPressed: isSaving
                  ? null
                  : () {
                      final updated = state.settings.copyWith(
                        storeName: _storeNameController.text.trim(),
                        supportEmail: _supportEmailController.text.trim(),
                        supportPhone: _supportPhoneController.text.trim(),
                        currency: _currencyController.text.trim(),
                        deliveryFee: _parseAmount(
                          _deliveryFeeController.text,
                          state.settings.deliveryFee,
                        ),
                        freeDeliveryThreshold: _parseAmount(
                          _freeDeliveryController.text,
                          state.settings.freeDeliveryThreshold,
                        ),
                        taxRate: _parseAmount(
                          _taxRateController.text,
                          state.settings.taxRate,
                          max: 100,
                        ),
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

  Widget _buildSystemMaintenanceCard(SettingsState state) {
    final theme = Theme.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);
    final isClearing = state.isClearingCache;

    return SectionCard(
      title: 'صيانة النظام والتخزين المؤقت',
      subtitle: 'إعادة ضبط ذاكرة التخزين المؤقت للبيانات وتحديث التطبيق',
      icon: Icons.cleaning_services_rounded,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppDesignTokens.space16,
        runSpacing: AppDesignTokens.space12,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفريغ الذاكرة المؤقتة',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.space4),
                Text(
                  'مسح البيانات المؤقتة المحلية لإجبار لوحة التحكم على جلب أحدث البيانات فوراً من الخادم.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: isClearing ? null : controller.clearCache,
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

  Widget _buildAdminsCard(AsyncValue<UsersStatsEntity> usersAsync) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SectionCard(
      title: 'إدارة المشرفين والصلاحيات',
      subtitle: 'قائمة الحسابات الإدارية المصرح لها بإدارة لوحة التحكم',
      icon: Icons.admin_panel_settings_rounded,
      child: usersAsync.when(
        loading: () => const Padding(
          padding: AppDesignTokens.paddingCard,
          child: EnhancedLoadingWidget(message: 'جاري تحميل قائمة المشرفين...'),
        ),
        error: (error, _) => EnhancedErrorWidget.fromError(
          error,
          fallbackTitle: 'تعذر تحميل قائمة المشرفين',
          onRetry: () => ref.read(usersNotifierProvider.notifier).refresh(),
        ),
        data: (stats) {
          final admins = stats.users
              .where((user) => user.role.toLowerCase() == 'admin')
              .toList();

          if (admins.isEmpty) {
            return Text(
              'لا يوجد مسؤولين مسجلين حالياً',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            );
          }

          return DividedColumn(
            children: [
              for (final admin in admins)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      admin.name.isNotEmpty ? admin.name[0].toUpperCase() : 'A',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    admin.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(admin.email ?? 'لا يوجد بريد إلكتروني مسجل'),
                  trailing: InfoPill(
                    label: admin.role.toUpperCase(),
                    icon: Icons.shield_outlined,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountSessionCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return SectionCard(
      title: 'جلسة العمل والحساب',
      subtitle: 'إنهاء الجلسة الإدارية الحالية وتسجيل الخروج بأمان',
      icon: Icons.account_circle_rounded,
      child: FilledButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('تسجيل الخروج من لوحة التحكم'),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          minimumSize: const Size.fromHeight(52),
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

/// مفتاح إعداد بعنوان ووصف
class _SettingSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
