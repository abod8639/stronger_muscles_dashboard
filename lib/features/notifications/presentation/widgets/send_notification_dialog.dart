import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

void showSendNotificationDialog(BuildContext context) {
  final controller = Get.find<NotificationsController>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final userIdController = TextEditingController();
  final imageUrlController = TextEditingController();

  final selectedType = 'general'.obs;
  final targetType = 'all'.obs;
  final formKey = GlobalKey<FormState>();

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;

  Get.dialog(
    Dialog(
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
            key: formKey,
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
                        onPressed: () => Get.back(),
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
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('جميع المستخدمين (عام)')),
                            selected: targetType.value == 'all',
                            avatar: const Icon(Icons.public_rounded, size: 18),
                            onSelected: (val) {
                              if (val) targetType.value = 'all';
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('مستخدم محدد')),
                            selected: targetType.value == 'user',
                            avatar: const Icon(Icons.person_rounded, size: 18),
                            onSelected: (val) {
                              if (val) targetType.value = 'user';
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // User ID (if targetType == 'user')
                  Obx(() {
                    if (targetType.value != 'user') return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TextFormField(
                        controller: userIdController,
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
                          if (targetType.value == 'user' && (value == null || value.trim().isEmpty)) {
                            return 'يرجى إدخال معرف المستخدم';
                          }
                          return null;
                        },
                      ),
                    );
                  }),

                  // Notification Type
                  Text(
                    'نوع الإشعار',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('عام'),
                          selected: selectedType.value == 'general',
                          onSelected: (v) => selectedType.value = 'general',
                        ),
                        ChoiceChip(
                          label: const Text('إعلان / عرض'),
                          selected: selectedType.value == 'promo',
                          onSelected: (v) => selectedType.value = 'promo',
                        ),
                        ChoiceChip(
                          label: const Text('طلب'),
                          selected: selectedType.value == 'order',
                          onSelected: (v) => selectedType.value = 'order',
                        ),
                        ChoiceChip(
                          label: const Text('نظام / تنبيه'),
                          selected: selectedType.value == 'system',
                          onSelected: (v) => selectedType.value = 'system',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title Field
                  TextFormField(
                    controller: titleController,
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
                    controller: bodyController,
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
                    controller: imageUrlController,
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
                        onPressed: () => Get.back(),
                        child: const Text('إلغاء'),
                      ),
                      const SizedBox(width: 12),
                      Obx(
                        () => FilledButton.icon(
                          onPressed: controller.isSending.value
                              ? null
                              : () async {
                                  if (formKey.currentState?.validate() ?? false) {
                                    final success = await controller.sendNotification(
                                      title: titleController.text.trim(),
                                      body: bodyController.text.trim(),
                                      type: selectedType.value,
                                      targetType: targetType.value,
                                      userId: targetType.value == 'user'
                                          ? userIdController.text.trim()
                                          : null,
                                      imageUrl: imageUrlController.text.trim().isNotEmpty
                                          ? imageUrlController.text.trim()
                                          : null,
                                    );
                                    if (success) {
                                      Get.back();
                                    }
                                  }
                                },
                          icon: controller.isSending.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send_rounded, size: 18),
                          label: Text(controller.isSending.value ? 'جاري الإرسال...' : 'إرسال الإشعار'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
