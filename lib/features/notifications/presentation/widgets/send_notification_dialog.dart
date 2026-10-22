import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../controllers/notifications_providers.dart';

void showSendNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const SendNotificationDialog(),
  );
}

class SendNotificationDialog extends ConsumerStatefulWidget {
  const SendNotificationDialog({super.key});

  @override
  ConsumerState<SendNotificationDialog> createState() =>
      _SendNotificationDialogState();
}

class _SendNotificationDialogState extends ConsumerState<SendNotificationDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'general';
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

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSending = true);

    final payload = <String, dynamic>{
      'title': _titleController.text.trim(),
      'body': _bodyController.text.trim(),
      'type': _selectedType,
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
      result.fold(
        (failure) => AppFeedback.showError(failure.message),
        (_) {
          AppFeedback.showSuccess('تم إرسال الإشعار بنجاح');
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.05)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.12)!,
                  ]
                : [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.90)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.04)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.7)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.5),
              offset: const Offset(6, 8),
              blurRadius: 20,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.9),
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.send_rounded, color: colorScheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
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
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // Target Audience
                  Text(
                    'الجمهور المستهدف',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('جميع المستخدمين (عام)')),
                          selected: _targetType == 'all',
                          avatar: const Icon(Icons.public_rounded, size: 18),
                          onSelected: (val) {
                            if (val) setState(() => _targetType = 'all');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Center(child: Text('مستخدم محدد')),
                          selected: _targetType == 'user',
                          avatar: const Icon(Icons.person_rounded, size: 18),
                          onSelected: (val) {
                            if (val) setState(() => _targetType = 'user');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // User ID (if _targetType == 'user')
                  if (_targetType == 'user')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TextFormField(
                        controller: _userIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'معرف المستخدم (User ID) *',
                          hintText: 'أدخل معرّف العميل المستهدف...',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (value) {
                          if (_targetType == 'user' && (value == null || value.trim().isEmpty)) {
                            return 'يرجى إدخال معرف المستخدم';
                          }
                          return null;
                        },
                      ),
                    ),

                  // Notification Type
                  Text(
                    'نوع الإشعار',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('عام'),
                        selected: _selectedType == 'general',
                        onSelected: (v) => setState(() => _selectedType = 'general'),
                      ),
                      ChoiceChip(
                        label: const Text('إعلان / عرض'),
                        selected: _selectedType == 'promo',
                        onSelected: (v) => setState(() => _selectedType = 'promo'),
                      ),
                      ChoiceChip(
                        label: const Text('طلب'),
                        selected: _selectedType == 'order',
                        onSelected: (v) => setState(() => _selectedType = 'order'),
                      ),
                      ChoiceChip(
                        label: const Text('نظام / تنبيه'),
                        selected: _selectedType == 'system',
                        onSelected: (v) => setState(() => _selectedType = 'system'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'عنوان الإشعار *',
                      hintText: 'مثال: عرض نهاية الأسبوع!',
                      prefixIcon: const Icon(Icons.title_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال عنوان الإشعار';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Body Field
                  TextFormField(
                    controller: _bodyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'نص الرسالة *',
                      hintText: 'أدخل تفاصيل الإشعار هنا...',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Icon(Icons.notes_rounded),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال نص الإشعار';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Image URL (Optional)
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'رابط الصورة (اختياري)',
                      hintText: 'https://example.com/image.jpg',
                      prefixIcon: const Icon(Icons.image_outlined),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSending ? null : () => Navigator.of(context).pop(),
                        child: const Text('إلغاء'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _isSending ? null : _handleSubmit,
                        icon: _isSending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, size: 18),
                        label: Text(_isSending ? 'جاري الإرسال...' : 'إرسال الإشعار'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
