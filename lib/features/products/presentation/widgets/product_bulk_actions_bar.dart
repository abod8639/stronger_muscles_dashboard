import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import '../controllers/products_controller.dart';

class ProductBulkActionsBar extends StatelessWidget {
  const ProductBulkActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final responsive = context.responsive;

    return Obx(() {
      final selectedCount = controller.selectedCount;
      final isOperating = controller.isBulkOperating.value;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.defaultPadding.left,
          vertical: 6,
        ),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(20),
          opacity: 0.12,
          blur: 20,
          border: Border.all(
            color: selectedCount > 0
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.2,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: isOperating
                ? _buildOperatingState()
                : _buildActionBar(context, controller, responsive, selectedCount),
          ),
        ),
      );
    });
  }

  Widget _buildOperatingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'جاري تنفيذ العملية الجماعية...',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
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
  ) {
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
                    activeColor: AppColors.primary,
                    checkColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: selectedCount > 0
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedCount > 0
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    selectedCount > 0
                        ? '$selectedCount محدد'
                        : 'تحديد الكل',
                    style: TextStyle(
                      color: selectedCount > 0
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
            color: AppColors.success,
            label: responsive.isMobile ? null : 'تفعيل',
            onTap: () => controller.bulkToggleStatus(activate: true),
          ),
          const SizedBox(width: 8),

          // تعطيل
          _buildActionButton(
            tooltip: 'تعطيل المنتجات المحددة',
            icon: Icons.pause_circle_outline_rounded,
            color: AppColors.warning,
            label: responsive.isMobile ? null : 'تعطيل',
            onTap: () => controller.bulkToggleStatus(activate: false),
          ),
          const SizedBox(width: 8),

          // نقل لقسم
          _buildActionButton(
            tooltip: 'تغيير قسم المنتجات المحددة',
            icon: Icons.drive_file_move_rounded,
            color: AppColors.info,
            label: responsive.isMobile ? null : 'نقل',
            onTap: () => _showCategoryPickerDialog(context, controller),
          ),
          const SizedBox(width: 8),

          // حذف
          _buildActionButton(
            tooltip: 'حذف المنتجات المحددة',
            icon: Icons.delete_outline_rounded,
            color: AppColors.error,
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
          color: Colors.white70,
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
    required Color color,
    String? label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: label != null ? 10 : 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: color),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPickerDialog(
    BuildContext context,
    ProductsController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'اختر القسم الجديد للمنتجات المحددة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
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
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    tileColor: Colors.white.withValues(alpha: 0.03),
                    title: Text(
                      category.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white38,
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
