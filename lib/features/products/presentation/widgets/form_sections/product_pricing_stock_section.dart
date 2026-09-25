import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'form_section_card.dart';
import 'modern_form_field.dart';

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
          Obx(() {
            final hasSizes = controller.productSizes.isNotEmpty;
            if (hasSizes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Color.lerp(colorScheme.secondaryContainer,
                                    Colors.white, 0.02)!,
                                Color.lerp(colorScheme.secondaryContainer,
                                    Colors.black, 0.12)!,
                              ]
                            : [
                                Color.lerp(colorScheme.secondaryContainer,
                                    Colors.white, 0.40)!,
                                Color.lerp(colorScheme.secondaryContainer,
                                    Colors.black, 0.02)!,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.30)
                              : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                          offset: const Offset(1.5, 2),
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.02)
                              : Colors.white.withValues(alpha: 0.85),
                          offset: const Offset(-1.5, -1.5),
                          blurRadius: 2.5,
                        ),
                      ],
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.03)
                            : Colors.white.withValues(alpha: 0.80),
                        width: 0.8,
                      ),
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        Color.lerp(
                                            colorScheme.surfaceContainerHigh,
                                            Colors.white,
                                            0.02)!,
                                        Color.lerp(
                                            colorScheme.surfaceContainerHigh,
                                            Colors.black,
                                            0.10)!,
                                      ]
                                    : [
                                        Colors.white,
                                        Color.lerp(
                                            colorScheme.surfaceContainerLow,
                                            Colors.black,
                                            0.03)!,
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.35)
                                      : const Color(0xFFA3B1C6)
                                          .withValues(alpha: 0.30),
                                  offset: const Offset(1.5, 2),
                                  blurRadius: 3,
                                ),
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.02)
                                      : Colors.white.withValues(alpha: 0.90),
                                  offset: const Offset(-1.5, -1.5),
                                  blurRadius: 2.5,
                                ),
                              ],
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.03)
                                    : Colors.white.withValues(alpha: 0.85),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              size.size,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernFormField(
                              controller: priceCtrl,
                              label: 'سعر (${size.size})',
                              icon: Icons.price_change_outlined,
                              isNumber: true,
                              suffixText: 'ر.س',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernFormField(
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
                  child: ModernFormField(
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
                  child: ModernFormField(
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
          }),

          const SizedBox(height: 18),

          // Stock & Servings Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ModernFormField(
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
                child: ModernFormField(
                  controller: controller.textcontrollers['serving']!,
                  label: 'حجم الحصة',
                  hint: 'مثال: 30g',
                  icon: Icons.scale_outlined,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ModernFormField(
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
