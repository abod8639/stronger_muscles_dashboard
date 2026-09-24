import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم تحديد وجهة الإعلان (عام، منتج محدد، أو ماركة تجارية)
class PromoTargetSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoTargetSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'none',
                  label: Text('عام (بدون توجيه)'),
                  icon: Icon(Icons.block_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'product',
                  label: Text('منتج محدد'),
                  icon: Icon(Icons.inventory_2_rounded, size: 18),
                ),
                ButtonSegment<String>(
                  value: 'brand',
                  label: Text('ماركة تجارية'),
                  icon: Icon(Icons.category_rounded, size: 18),
                ),
              ],
              selected: {controller.selectedTargetType.value},
              onSelectionChanged: (newSelection) {
                controller.selectedTargetType.value = newSelection.first;
                controller.selectedTargetId.value = null;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.selectedTargetType.value == 'product') {
            return _buildProductDropdown(context);
          } else if (controller.selectedTargetType.value == 'brand') {
            return _buildBrandDropdown(context);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildProductDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل قائمة المنتجات...');
      }

      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedTargetId.value,
            hint: Text(
              'اختر منتجاً لربط الإعلان به...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            items: products.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            p.imageUrls.isNotEmpty ? p.imageUrls.first : '',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        placeholder: (_, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.nameAr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => controller.selectedTargetId.value = val,
          ),
        ),
      );
    });
  }

  Widget _buildBrandDropdown(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final brands = controller.brands;
      final isFetching = controller.isBrandsLoading.value;

      if (isFetching && brands.isEmpty) {
        return _loadingDropdown(context, 'جاري تحميل قائمة الماركات...');
      }

      if (brands.isEmpty) {
        return _emptyState(context, 'لا توجد ماركات مسجلة حالياً');
      }

      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: brands.any((b) => b.id == controller.selectedTargetId.value)
                ? controller.selectedTargetId.value
                : null,
            hint: Text(
              'اختر ماركة لربط الإعلان بها...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            dropdownColor: colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            items: brands.map((b) {
              return DropdownMenuItem<String>(
                value: b.id,
                child: Row(
                  children: [
                    if (b.imageUrl != null && b.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: b.imageUrl!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          placeholder: (_, _) => Icon(
                            Icons.category,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.category_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 28,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        b.displayName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => controller.selectedTargetId.value = val,
          ),
        ),
      );
    });
  }

  Widget _loadingDropdown(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
