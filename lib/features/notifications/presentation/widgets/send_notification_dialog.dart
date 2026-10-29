import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/components/chip_item.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../controllers/notifications_providers.dart';
import 'notification_type_ui.dart';

/// Helper function to display the notification creation modal dialog.
void showSendNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const SendNotificationDialog(),
  );
}

/// Dialog allowing administrators to compose and dispatch broadcast or targeted notifications.
class SendNotificationDialog extends ConsumerStatefulWidget {
  const SendNotificationDialog({super.key});

  @override
  ConsumerState<SendNotificationDialog> createState() =>
      _SendNotificationDialogState();
}

class _SendNotificationDialogState
    extends ConsumerState<SendNotificationDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  NotificationTypeUi _selectedType = NotificationTypeUi.general;
  String _targetType = 'all';
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  Future<void> _handleSubmit() async {
    if (_isSending) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSending = true);

    final payload = <String, dynamic>{
      'title': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
      'type': _selectedType.id,
      'target_type': _targetType,
      if (_targetType == 'user') 'user_id': _userIdController.text.trim(),
      if (_imageUrlController.text.trim().isNotEmpty)
        'image_url': _imageUrlController.text.trim(),
    };

    final result = await ref
        .read(notificationsControllerProvider.notifier)
        .sendNotification(payload);

    if (mounted) {
      setState(() => _isSending = false);
      result.fold((failure) => AppFeedback.showError(failure.message), (_) {
        AppFeedback.showSuccess('تم إرسال الإشعار بنجاح');
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;
    final gap = SizedBox(
      height: isMobile ? AppDesignTokens.space12 : AppDesignTokens.space16,
    );

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDesignTokens.space12
            : AppDesignTokens.space32,
        vertical: AppDesignTokens.space24,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppDesignTokens.radiusPill),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(
              isMobile ? AppDesignTokens.space16 : AppDesignTokens.space24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    const IconCardWithShadow(
                      icon: Icons.send_rounded,
                      size: 22,
                      padding: EdgeInsets.all(AppDesignTokens.space10),
                      borderRadius: AppDesignTokens.radiusMediumValue,
                    ),
                    const SizedBox(width: AppDesignTokens.space12),
                    Expanded(
                      child: Text(
                        'إرسال إشعار جديد',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _isSending
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'إغلاق',
                    ),
                  ],
                ),
                const Divider(height: 28),

                // Target Audience
                const _SectionLabel('الجمهور المستهدف'),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: 'all',
                      label: Text('جميع المستخدمين'),
                      icon: Icon(Icons.public_rounded),
                    ),
                    ButtonSegment(
                      value: 'user',
                      label: Text('مستخدم محدد'),
                      icon: Icon(Icons.person_rounded),
                    ),
                  ],
                  selected: {_targetType},
                  onSelectionChanged: _isSending
                      ? null
                      : (value) => setState(() => _targetType = value.first),
                ),
                if (_targetType == 'user') ...[
                  gap,
                  ModernTextField(
                    controller: _userIdController,
                    enabled: !_isSending,
                    label: 'معرف المستخدم (User ID) *',
                    hint: 'أدخل معرّف العميل المستهدف...',
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) => _required(v, 'يرجى إدخال معرف المستخدم'),
                  ),
                ],
                gap,

                // Notification Type
                const _SectionLabel('نوع الإشعار'),
                Wrap(
                  spacing: AppDesignTokens.space8,
                  runSpacing: AppDesignTokens.space8,
                  children: [
                    for (final type in NotificationTypeUi.values)
                      ChipItem(
                        label: type.label,
                        isSelected: _selectedType == type,
                        index: 0,
                        onTap: () {
                          if (!_isSending) setState(() => _selectedType = type);
                        },
                      ),
                  ],
                ),
                gap,

                ModernTextField(
                  controller: _titleController,
                  enabled: !_isSending,
                  label: 'عنوان الإشعار *',
                  hint: 'مثال: عرض نهاية الأسبوع!',
                  icon: Icons.title_rounded,
                  validator: (v) => _required(v, 'يرجى إدخال عنوان الإشعار'),
                ),
                gap,
                ModernTextField(
                  controller: _bodyController,
                  enabled: !_isSending,
                  label: 'نص الرسالة *',
                  hint: 'أدخل تفاصيل الإشعار هنا...',
                  icon: Icons.notes_rounded,
                  maxLines: 4,
                  validator: (v) => _required(v, 'يرجى إدخال نص الإشعار'),
                ),
                gap,
                ModernTextField(
                  controller: _imageUrlController,
                  enabled: !_isSending,
                  label: 'رابط الصورة (اختياري)',
                  hint: 'https://example.com/image.jpg',
                  icon: Icons.image_outlined,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: AppDesignTokens.space24),

                // Action Buttons
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppDesignTokens.space12,
                  runSpacing: AppDesignTokens.space8,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                    FilledButton.icon(
                      onPressed: _isSending ? null : _handleSubmit,
                      icon: _isSending
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        _isSending ? 'جاري الإرسال...' : 'إرسال الإشعار',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignTokens.space8),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
