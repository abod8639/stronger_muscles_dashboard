import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';

/// حقل معرف التصنيف الفريد (System ID) مع حماية القفل المزدوج والتنبيه الأمني بنمط M3
class CategoryIdField extends StatefulWidget {
  final CategoriesController controller;
  final CategoryEntity? category;

  const CategoryIdField({
    super.key,
    required this.controller,
    this.category,
  });

  @override
  State<CategoryIdField> createState() => _CategoryIdFieldState();
}

class _CategoryIdFieldState extends State<CategoryIdField> {
  bool _isIdFieldEnabled = false;

  void _toggleIdLock() {
    if (!_isIdFieldEnabled && widget.category != null) {
      Get.dialog(
        ConfirmDialog(
          title: '⚠️ تنبيه الأمان',
          message:
              'تعديل المعرف (ID) للتصنيف الحالي قد يؤدي إلى:\n• كسر الروابط القديمة\n• مشاكل في ربط المنتجات بالقاعدة\n• فقدان البيانات المرتبطة\n\nهل أنت متأكد من فك القفل والمتابعة؟',
          confirmText: 'نعم، فك القفل',
          onConfirm: () {
            setState(() => _isIdFieldEnabled = true);
            HapticFeedback.mediumImpact();
            Get.back();
          },
        ),
      );
    } else {
      setState(() => _isIdFieldEnabled = !_isIdFieldEnabled);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.category != null;

    final Color activeColor = _isIdFieldEnabled
        ? colorScheme.error
        : colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المعرف الفريد للنظام (System ID)',
              style: theme.textTheme.labelMedium?.copyWith(
                color: activeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isEditing)
              InkWell(
                onTap: _toggleIdLock,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isIdFieldEnabled
                            ? Icons.lock_open_rounded
                            : Icons.lock_outline_rounded,
                        size: 15,
                        color: activeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isIdFieldEnabled ? 'القفل مفتوح' : 'انقر مرتين أو هنا لفك القفل',
                        style: TextStyle(
                          fontSize: 11,
                          color: activeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onDoubleTap: _toggleIdLock,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _isIdFieldEnabled
                  ? colorScheme.errorContainer.withValues(alpha: 0.12)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              border: Border.all(
                color: _isIdFieldEnabled
                    ? colorScheme.error.withValues(alpha: 0.7)
                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
                width: _isIdFieldEnabled ? 1.5 : 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ModernTextField(
                  controller: widget.controller.idController,
                  label: 'المعرف: مثلاً supplements_creatine',
                  icon: Icons.terminal_rounded,
                  enabled: (!isEditing || _isIdFieldEnabled) &&
                      !widget.controller.isLoading.value,
                ),
                if (isEditing)
                  Positioned(
                    left: 14,
                    child: IconButton(
                      icon: Icon(
                        _isIdFieldEnabled
                            ? Icons.lock_open_rounded
                            : Icons.lock_rounded,
                        color: activeColor,
                        size: 20,
                      ),
                      tooltip: _isIdFieldEnabled ? 'إعادة قفل الحقل' : 'فك قفل الحقل',
                      onPressed: _toggleIdLock,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
