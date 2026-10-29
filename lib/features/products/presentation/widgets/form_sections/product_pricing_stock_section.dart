import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/form_section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';

/// قسم التسعير والمخزون والحصص للمنتج بتصميم Neumorphism / Soft UI
class ProductPricingStockSection extends StatelessWidget {
  final ProductsController controller;

  const ProductPricingStockSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return FormSectionCard(
      title: 'التسعير والمخزون',
      subtitle: 'الأسعار، الخصومات، المخزون، والقيم الغذائية',
      icon: Icons.payments_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pricing Row
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
            final hasSizes = controller.productSizes.isNotEmpty;
            if (hasSizes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: AppDesignTokens.softSurface(
                      colorScheme,
                      isDark: isDark,
                      borderRadius: BorderRadius.circular(12),
                      compact: true,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تم تفعيل تسعير مخصص حسب الأحجام المحددة أدناه:',
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

                      if (priceCtrl == null || discountCtrl == null) {
                        return const SizedBox.shrink();
                      }

                      return Row(
                        children: [
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
                            child: Text(
                              size.size,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              controller: priceCtrl,
                              label: 'سعر (${size.size})',
                              icon: Icons.price_change_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              controller: discountCtrl,
                              label: 'سعر الخصم',
                              icon: Icons.sell_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            }

            return Row(
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
                    suffixText: 'ر.س',
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
                    suffixText: 'ر.س',
                  ),
                ),
              ],
            );
          },
        ),

          const SizedBox(height: 18),

          // Stock & Servings Row
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
                  label: 'حجم الحصة',
                  hint: 'مثال: 30g',
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
          ),
        ],
      ),
    );
  }
}
