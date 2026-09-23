import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import '../controllers/products_controller.dart';

class ProductBulkActionsBar extends StatelessWidget {
  const ProductBulkActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final selectedCount = controller.selectedCount;
      final isOperating = controller.isBulkOperating.value;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.defaultPadding.left,
          vertical: 6,
        ),
        child: Card(
          elevation: 2,
          color: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selectedCount > 0
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: isOperating
                ? _buildOperatingState(theme)
                : _buildActionBar(
                    context,
                    controller,
                    responsive,
                    selectedCount,
                    theme,
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildOperatingState(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'جاري تنفيذ العملية الجماعية...',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    ProductsController controller,
    dynamic responsive,
    int selectedCount,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // 1. Select All Checkbox + Count Badge
        InkWell(
          onTap: () => controller.toggleSelectAll(),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: controller.isAllSelected,
                    onChanged: (_) => controller.toggleSelectAll(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: selectedCount > 0
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedCount > 0
                        ? '$selectedCount محدد'
                        : 'تحديد الكل',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: selectedCount > 0
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // 2. Action Buttons (Only enabled when selectedCount > 0)
        if (selectedCount > 0) ...[
          // تفعيل
          _buildActionButton(
            tooltip: 'تفعيل المنتجات المحددة',
            icon: Icons.check_circle_outline_rounded,
            bgColor: colorScheme.primaryContainer,
            fgColor: colorScheme.onPrimaryContainer,
            label: responsive.isMobile ? null : 'تفعيل',
            onTap: () => controller.bulkToggleStatus(activate: true),
          ),
          const SizedBox(width: 8),

          // تعطيل
          _buildActionButton(
            tooltip: 'تعطيل المنتجات المحددة',
            icon: Icons.pause_circle_outline_rounded,
            bgColor: colorScheme.secondaryContainer,
            fgColor: colorScheme.onSecondaryContainer,
            label: responsive.isMobile ? null : 'تعطيل',
            onTap: () => controller.bulkToggleStatus(activate: false),
          ),
          const SizedBox(width: 8),

          // نقل لقسم
          _buildActionButton(
            tooltip: 'تغيير قسم المنتجات المحددة',
            icon: Icons.drive_file_move_rounded,
            bgColor: colorScheme.tertiaryContainer,
            fgColor: colorScheme.onTertiaryContainer,
            label: responsive.isMobile ? null : 'نقل',
            onTap: () => _showCategoryPickerDialog(context, controller),
          ),
          const SizedBox(width: 8),

          // حذف
          _buildActionButton(
            tooltip: 'حذف المنتجات المحددة',
            icon: Icons.delete_outline_rounded,
            bgColor: colorScheme.errorContainer,
            fgColor: colorScheme.onErrorContainer,
            label: responsive.isMobile ? null : 'حذف',
            onTap: () => controller.confirmBulkDelete(),
          ),
          const SizedBox(width: 8),
        ],

        // 3. Exit Selection Mode Button
        IconButton(
          onPressed: () => controller.toggleSelectionMode(false),
          icon: const Icon(Icons.close_rounded, size: 20),
          tooltip: 'إلغاء وضع التحديد',
          color: colorScheme.onSurfaceVariant,
          splashRadius: 18,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String tooltip,
    required IconData icon,
    required Color bgColor,
    required Color fgColor,
    String? label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 10 : 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 17, color: fgColor),
                if (label != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryPickerDialog(
    BuildContext context,
    ProductsController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اختر القسم الجديد للمنتجات المحددة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    tileColor: colorScheme.surfaceContainerHigh,
                    title: Text(
                      category.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    onTap: () {
                      controller.bulkChangeCategory(category.id);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
