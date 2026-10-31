import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';

/// قسم التسعير والمخزون والحصص للمنتج بتصميم Neumorphism / Soft UI
class ProductPricingStockSection extends ConsumerWidget {
  final ProductsController controller;

  const ProductPricingStockSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(storeCurrencyProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SectionCard(
      title: 'التسعير والمخزون',
      subtitle: 'الأسعار، الخصومات، المخزون، والقيم الغذائية',
      icon: Icons.payments_outlined,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final hasSizes = controller.productSizes.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSizes) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: AppDesignTokens.softSurface(
                    colorScheme,
                    isDark: isDark,
                    borderRadius: BorderRadius.circular(12),
                    compact: true,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'تم تفعيل تخصيص السعر، الخصم، المخزون، الحصص، والوزن لكل حجم على حدة:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.productSizes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final size = controller.productSizes[i];
                    final priceCtrl =
                        controller.sizePriceControllers[size.size];
                    final discountCtrl =
                        controller.sizeDiscountControllers[size.size];
                    final servingsCtrl =
                        controller.sizeServingsControllers[size.size];
                    final weightCtrl =
                        controller.sizeWeightControllers[size.size];
                    final stockCtrl =
                        controller.sizeStockControllers[size.size];

                    if (priceCtrl == null ||
                        discountCtrl == null ||
                        servingsCtrl == null ||
                        weightCtrl == null ||
                        stockCtrl == null) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: AppDesignTokens.softSurface(
                        colorScheme,
                        isDark: isDark,
                        borderRadius: BorderRadius.circular(14),
                        compact: true,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.straighten_rounded,
                                      size: 14,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      size.size,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isCompact = constraints.maxWidth < 650;
                              if (isCompact) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ModernTextField(
                                            controller: priceCtrl,
                                            label: 'السعر',
                                            icon: Icons.price_change_outlined,
                                            isNumber: true,
                                            isRequired: true,
                                            suffixText: currency,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ModernTextField(
                                            controller: discountCtrl,
                                            label: 'سعر الخصم',
                                            icon: Icons.sell_outlined,
                                            isNumber: true,
                                            suffixText: currency,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ModernTextField(
                                            controller: stockCtrl,
                                            label: 'الكمية في المخزن',
                                            hint: 'مثال: 50',
                                            icon: Icons.inventory_2_outlined,
                                            isNumber: true,
                                            isRequired: true,
                                            suffixText: 'قطعة',
                                            onChanged: (_) =>
                                                controller.notifySizeStockChanged(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ModernTextField(
                                            controller: servingsCtrl,
                                            label: 'عدد الحصص',
                                            hint: 'مثال: 60',
                                            icon: Icons
                                                .format_list_numbered_rtl_rounded,
                                            isNumber: true,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ModernTextField(
                                            controller: weightCtrl,
                                            label: 'الوزن / حجم الحصة',
                                            hint: 'مثال: 1kg أو 30g',
                                            icon: Icons.scale_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ModernTextField(
                                          controller: priceCtrl,
                                          label: 'السعر',
                                          icon: Icons.price_change_outlined,
                                          isNumber: true,
                                          isRequired: true,
                                          suffixText: currency,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ModernTextField(
                                          controller: discountCtrl,
                                          label: 'سعر الخصم',
                                          icon: Icons.sell_outlined,
                                          isNumber: true,
                                          suffixText: currency,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ModernTextField(
                                          controller: stockCtrl,
                                          label: 'الكمية في المخزن',
                                          hint: 'مثال: 50',
                                          icon: Icons.inventory_2_outlined,
                                          isNumber: true,
                                          isRequired: true,
                                          suffixText: 'قطعة',
                                          onChanged: (_) =>
                                              controller.notifySizeStockChanged(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ModernTextField(
                                          controller: servingsCtrl,
                                          label: 'عدد الحصص',
                                          hint: 'مثال: 60',
                                          icon: Icons
                                              .format_list_numbered_rtl_rounded,
                                          isNumber: true,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ModernTextField(
                                          controller: weightCtrl,
                                          label: 'الوزن / حجم الحصة',
                                          hint: 'مثال: 1kg أو 30g',
                                          icon: Icons.scale_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ModernTextField(
                        controller: controller.textcontrollers['price']!,
                        label: 'السعر الأساسي',
                        hint: '0.00',
                        icon: Icons.price_change_outlined,
                        isNumber: true,
                        isRequired: true,
                        suffixText: currency,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ModernTextField(
                        controller: controller.textcontrollers['discount']!,
                        label: 'سعر الخصم (اختياري)',
                        hint: '0.00',
                        icon: Icons.sell_outlined,
                        isNumber: true,
                        suffixText: currency,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 18),

              // Stock & Servings Row
              if (!hasSizes)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ModernTextField(
                        controller: controller.textcontrollers['stock']!,
                        label: 'الكمية في المخزن',
                        hint: '50',
                        icon: Icons.inventory_2_outlined,
                        isNumber: true,
                        isRequired: true,
                        suffixText: 'قطعة',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ModernTextField(
                        controller: controller.textcontrollers['serving']!,
                        label: 'حجم الحصة / الوزن',
                        hint: 'مثال: 30g أو 1kg',
                        icon: Icons.scale_outlined,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ModernTextField(
                        controller: controller.textcontrollers['sessions']!,
                        label: 'عدد الحصص',
                        hint: 'مثال: 60',
                        icon: Icons.format_list_numbered_rtl_rounded,
                        isNumber: true,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: AppDesignTokens.softSurface(
                    colorScheme,
                    isDark: isDark,
                    borderRadius: BorderRadius.circular(12),
                    compact: true,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إجمالي المخزون المتوفر (لجميع الأحجام)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${controller.totalSizesStock} قطعة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: isDark ? 0.3 : 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'محسوب تلقائياً من كميات الأحجام',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
