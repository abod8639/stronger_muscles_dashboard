import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/build_modern_text_field.dart';
import '../flavor_multi_select.dart';

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
              // السعر الأساسي وسعر الخصم (متاح وقابل للتعديل دائماً)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['price']!,
                      label: hasSizes
                          ? 'السعر الأساسي (الافتراضي)'
                          : 'السعر الأساسي',
                      hint: '0.00',
                      icon: Icons.price_change_outlined,
                      isNumber: true,
                      isRequired: !hasSizes,
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

              const SizedBox(height: 18),

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
                          'تخصيص السعر، الخصم، المخزون، الحصص، والوزن لكل حجم (قابلة للتعديل بحرية في أي وقت):',
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
                    if (controller.sizePriceControllers[size.size] == null ||
                        controller.sizeDiscountControllers[size.size] == null ||
                        controller.sizeServingsControllers[size.size] == null ||
                        controller.sizeWeightControllers[size.size] == null ||
                        controller.sizeStockControllers[size.size] == null) {
                      controller.syncSizeControllers(notify: false);
                    }

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
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.icecream_outlined,
                                        size: 15,
                                        color: colorScheme.primary,
                                      ),
                                      Text(
                                        'نكهات هذا الحجم: ',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      if (size.flavors != null &&
                                          size.flavors!.isNotEmpty)
                                        ...size.flavors!.map((raw) {
                                          final f = FlavorItem.fromRaw(raw);
                                          return Chip(
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            padding: EdgeInsets.zero,
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            label: Text(
                                              f.name,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          );
                                        })
                                      else
                                        Text(
                                          'لم تُحدد نكهات (يمكنك تخصيصها في قسم التنويعات أدناه)',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color:
                                                colorScheme.onSurfaceVariant,
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic,
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
                const SizedBox(height: 18),
              ],

              // صف المخزون والحصص (متاح وقابل للتعديل دائماً بحرية تامة)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['stock']!,
                      label: hasSizes
                          ? 'إجمالي المخزون في المستودع'
                          : 'الكمية في المخزن',
                      hint: '50',
                      icon: Icons.inventory_2_outlined,
                      isNumber: true,
                      isRequired: true,
                      suffixText: 'قطعة',
                      helperText: hasSizes
                          ? 'يمكنك تعديل إجمالي المخزون يدوياً بحرية في أي وقت'
                          : null,
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
              ),

              if (controller.variants.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(
                      alpha: isDark ? 0.2 : 0.35,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.secondary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'مجموع مخزون مصفوفة التنويعات (SKUs): ${controller.totalVariantsStock} قطعة.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          controller.textcontrollers['stock']?.text =
                              controller.totalVariantsStock.toString();
                          controller.notifySizeStockChanged();
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('تطبيق مجموع الـ SKUs'),
                      ),
                    ],
                  ),
                ),
              ] else if (hasSizes) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(
                      alpha: isDark ? 0.2 : 0.35,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sync_rounded,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'مجموع كميات الأحجام: ${controller.totalSizesStock} قطعة (يتزامن تلقائياً ويمكنك تخصيص إجمالي المخزون في الحقل أعلاه بحرية).',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          controller.textcontrollers['stock']?.text =
                              controller.totalSizesStock.toString();
                          controller.notifySizeStockChanged();
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('تطبيق مجموع الأحجام'),
                      ),
                    ],
                  ),
                ),
              ],

              // قسم القيم والحقائق الغذائية للمكملات (Nutrition Facts)
              const SizedBox(height: 24),
              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'الحقائق والقيم الغذائية للحصة (Nutrition Facts)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'القيم الغذائية لكل حصة من المكمل الرياضي (تظهر للعملاء في بطاقة تفاصيل المنتج)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),

              // صف السعرات والبروتين والكارب
              Row(
                children: [
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['calories']!,
                      label: 'السعرات (Calories)',
                      hint: 'مثال: 120 kcal',
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['protein']!,
                      label: 'البروتين (Protein)',
                      hint: 'مثال: 24g',
                      icon: Icons.fitness_center_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['carbs']!,
                      label: 'الكربوهيدرات (Carbs)',
                      hint: 'مثال: 3g',
                      icon: Icons.grain_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // صف الدهون والسكريات
              Row(
                children: [
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['fat']!,
                      label: 'الدهون (Total Fat)',
                      hint: 'مثال: 1.5g',
                      icon: Icons.opacity_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ModernTextField(
                      controller: controller.textcontrollers['sugar']!,
                      label: 'السكريات (Sugar)',
                      hint: 'مثال: 1g',
                      icon: Icons.cookie_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // مسببات الحساسية (Allergens)
              Text(
                'مسببات الحساسية (Allergen Warnings):',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final allergen in const [
                    'حليب (Milk)',
                    'صويا (Soy)',
                    'مكسرات (Tree Nuts)',
                    'بيض (Eggs)',
                    'جلوتين (Gluten)',
                    'فول سوداني (Peanuts)',
                    'سمك (Fish)',
                  ])
                    FilterChip(
                      selected: controller.allergens.contains(allergen),
                      label: Text(allergen),
                      onSelected: (_) => controller.toggleAllergen(allergen),
                      selectedColor: colorScheme.errorContainer.withValues(
                        alpha: 0.5,
                      ),
                      checkmarkColor: colorScheme.error,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: controller.allergens.contains(allergen)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: controller.allergens.contains(allergen)
                            ? colorScheme.error
                            : colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
