import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';

/// شريط الإجراءات السفلي المثبت لاستمارة المنتج بتصميم Neumorphism / Soft UI
class ProductStickyBottomBar extends StatelessWidget {
  final ProductsController controller;
  final VoidCallback onSave;
  final bool isEditing;

  const ProductStickyBottomBar({
    super.key,
    required this.controller,
    required this.onSave,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          // ظل علوي عاكس
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(0, -3),
            blurRadius: 8,
          ),
          // ظل سفلي للعمق
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.40)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Status Chip
          Obx(
            () {
              final isActive = controller.isActive.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                            Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.10)!,
                          ]
                        : [
                            Colors.white,
                            Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.02)!,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.30)
                          : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                      offset: const Offset(1, 1.5),
                      blurRadius: 2.5,
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.02)
                          : Colors.white.withValues(alpha: 0.85),
                      offset: const Offset(-1, -1),
                      blurRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.80),
                    width: 0.8,
                  ),
                ),
                child: InkWell(
                  onTap: () => controller.isActive.value = !isActive,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? colorScheme.primary : colorScheme.error,
                          boxShadow: [
                            BoxShadow(
                              color: (isActive ? colorScheme.primary : colorScheme.error)
                                  .withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isActive ? 'المنتج مفعّل' : 'مسودة غير مفعّلة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Spacer(),

          // Cancel Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : colorScheme.outlineVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          const SizedBox(width: 12),

          // Save FilledButton
          Obx(
            () => FilledButton.icon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
                  controller.isLoading.value || controller.isSaving.value
                      ? null
                      : onSave,
              icon: controller.isSaving.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: Text(
                controller.isSaving.value
                    ? 'جاري الحفظ...'
                    : (isEditing ? 'تحديث ونشر المنتج' : 'حفظ وإضافة المنتج'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
