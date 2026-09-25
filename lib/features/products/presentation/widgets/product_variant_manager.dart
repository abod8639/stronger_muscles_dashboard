import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// مدير تنويعات المنتج (SKUs) بتصميم Neumorphism / Soft UI
class ProductVariantManager extends StatelessWidget {
  final ProductsController controller;

  const ProductVariantManager({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تنويعات المنتج (SKUs)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              // Neumorphic Add Variant Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color.lerp(colorScheme.primaryContainer,
                                Colors.white, 0.02)!,
                            Color.lerp(colorScheme.surfaceContainer,
                                colorScheme.primary, 0.12)!,
                          ]
                        : [
                            Color.lerp(colorScheme.primaryContainer,
                                Colors.white, 0.40)!,
                            Color.lerp(colorScheme.primaryContainer,
                                Colors.black, 0.02)!,
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
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
                    color: colorScheme.primary
                        .withValues(alpha: isDark ? 0.6 : 0.7),
                    width: 1.0,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: controller.addVariant,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_rounded,
                              size: 18, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'إضافة تنويع',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.variants.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainerHigh,
                              Colors.white, 0.02)!,
                          Color.lerp(colorScheme.surfaceContainerHigh,
                              Colors.black, 0.12)!,
                        ]
                      : [
                          Colors.white,
                          Color.lerp(colorScheme.surfaceContainerLow,
                              Colors.black, 0.03)!,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.35)
                        : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
                    offset: const Offset(2, 2.5),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.white.withValues(alpha: 0.90),
                    offset: const Offset(-1.5, -1.5),
                    blurRadius: 3,
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color:
                          colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد تنويعات بعد. أضف واحداً لإدارة مخزون SKU.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.variants.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final variant = controller.variants[index];
                return _VariantItemEditor(
                  index: index,
                  variant: variant,
                  onUpdate: (updated) =>
                      controller.updateVariant(index, updated),
                  onDelete: () => controller.removeVariant(index),
                  availableSizes: controller.productSizes
                      .map((e) => e.size)
                      .toList(),
                  availableFlavors: controller.productFlavors,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _VariantItemEditor extends StatefulWidget {
  final int index;
  final ProductVariantEntity variant;
  final Function(ProductVariantEntity) onUpdate;
  final VoidCallback onDelete;
  final List<String> availableSizes;
  final List<String> availableFlavors;

  const _VariantItemEditor({
    required this.index,
    required this.variant,
    required this.onUpdate,
    required this.onDelete,
    required this.availableSizes,
    required this.availableFlavors,
  });

  @override
  State<_VariantItemEditor> createState() => _VariantItemEditorState();
}

class _VariantItemEditorState extends State<_VariantItemEditor> {
  late TextEditingController skuCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController discountCtrl;
  late TextEditingController stockCtrl;

  @override
  void initState() {
    super.initState();
    skuCtrl = TextEditingController(text: widget.variant.sku);
    priceCtrl = TextEditingController(text: widget.variant.price.toString());
    discountCtrl = TextEditingController(
      text: widget.variant.discountPrice?.toString() ?? '',
    );
    stockCtrl = TextEditingController(
      text: widget.variant.stockQuantity.toString(),
    );
  }

  @override
  void dispose() {
    skuCtrl.dispose();
    priceCtrl.dispose();
    discountCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  void _triggerUpdate() {
    final updated = ProductVariantEntity(
      id: widget.variant.id,
      sku: skuCtrl.text,
      price: double.tryParse(priceCtrl.text) ?? 0.0,
      discountPrice: double.tryParse(discountCtrl.text),
      effectivePrice: double.tryParse(priceCtrl.text) ?? 0.0,
      stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
      attributes: widget.variant.attributes,
      isActive: widget.variant.isActive,
    );
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white,
                      0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black,
                      0.10)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black,
                      0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
            offset: const Offset(2, 2.5),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Soft Number Badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Color.lerp(colorScheme.primaryContainer,
                                  Colors.white, 0.02)!,
                              Color.lerp(colorScheme.surfaceContainer,
                                  colorScheme.primary, 0.10)!,
                            ]
                          : [
                              Color.lerp(colorScheme.primaryContainer,
                                  Colors.white, 0.40)!,
                              Color.lerp(colorScheme.primaryContainer,
                                  Colors.black, 0.02)!,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.30)
                            : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.02)
                            : Colors.white.withValues(alpha: 0.85),
                        offset: const Offset(-1, -1),
                        blurRadius: 1.5,
                      ),
                    ],
                    border: Border.all(
                      color: colorScheme.primary
                          .withValues(alpha: isDark ? 0.5 : 0.6),
                      width: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'تنويع ${widget.index + 1}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                // Neumorphic Delete Button
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Color.lerp(colorScheme.surfaceContainerHigh,
                                  Colors.white, 0.02)!,
                              Color.lerp(colorScheme.surfaceContainerHigh,
                                  Colors.black, 0.10)!,
                            ]
                          : [
                              Colors.white,
                              Color.lerp(colorScheme.surfaceContainerLow,
                                  Colors.black, 0.02)!,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.30)
                            : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                        offset: const Offset(1, 1.5),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.02)
                            : Colors.white.withValues(alpha: 0.85),
                        offset: const Offset(-1, -1),
                        blurRadius: 1.5,
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
                    borderRadius: BorderRadius.circular(8),
                    onTap: widget.onDelete,
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: colorScheme.error,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildSoftTextField(
                    controller: skuCtrl,
                    label: 'رقم SKU',
                    icon: Icons.qr_code_scanner,
                    colorScheme: colorScheme,
                    isDark: isDark,
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSoftTextField(
                    controller: stockCtrl,
                    label: 'المخزون',
                    icon: Icons.inventory_2_outlined,
                    colorScheme: colorScheme,
                    isDark: isDark,
                    isNumber: true,
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSoftTextField(
                    controller: priceCtrl,
                    label: 'السعر',
                    icon: Icons.payments_outlined,
                    colorScheme: colorScheme,
                    isDark: isDark,
                    isNumber: true,
                    suffixText: 'ر.س',
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSoftTextField(
                    controller: discountCtrl,
                    label: 'الخصم',
                    icon: Icons.sell_outlined,
                    colorScheme: colorScheme,
                    isDark: isDark,
                    isNumber: true,
                    suffixText: 'ر.س',
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'السمات (Attributes)',
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
                _buildAttributeSelector(context, 'المقاس',
                    widget.availableSizes, 'size', colorScheme, isDark),
                _buildAttributeSelector(context, 'النكهة',
                    widget.availableFlavors, 'flavor', colorScheme, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    required bool isDark,
    bool isNumber = false,
    String? suffixText,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      onChanged: onChanged,
      style: TextStyle(color: colorScheme.onSurface, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        suffixText: suffixText,
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.4,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildAttributeSelector(
    BuildContext context,
    String label,
    List<String> options,
    String key,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (options.isEmpty) return const SizedBox.shrink();

    final currentVal = widget.variant.attributes[key];
    final hasVal = currentVal != null && currentVal.toString().isNotEmpty;

    return PopupMenuButton<String>(
      onSelected: (val) {
        final newAttrs = Map<String, dynamic>.from(widget.variant.attributes);
        newAttrs[key] = val;
        widget.onUpdate(ProductVariantEntity(
          id: widget.variant.id,
          sku: widget.variant.sku,
          price: widget.variant.price,
          discountPrice: widget.variant.discountPrice,
          effectivePrice: widget.variant.effectivePrice,
          stockQuantity: widget.variant.stockQuantity,
          attributes: newAttrs,
          isActive: widget.variant.isActive,
        ));
      },
      itemBuilder: (context) => options
          .map((opt) => PopupMenuItem(value: opt, child: Text(opt)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasVal
                ? (isDark
                    ? [
                        Color.lerp(colorScheme.primaryContainer, Colors.white,
                            0.02)!,
                        Color.lerp(colorScheme.surfaceContainer,
                            colorScheme.primary, 0.10)!,
                      ]
                    : [
                        Color.lerp(colorScheme.primaryContainer, Colors.white,
                            0.50)!,
                        Color.lerp(colorScheme.primaryContainer, Colors.black,
                            0.02)!,
                      ])
                : (isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.black, 0.10)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow,
                            Colors.black, 0.02)!,
                      ]),
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
            color: hasVal
                ? colorScheme.primary.withValues(alpha: isDark ? 0.6 : 0.7)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.80)),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color:
                  hasVal ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              currentVal ?? '$label: اختر',
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasVal ? FontWeight.bold : FontWeight.w500,
                color:
                    hasVal ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
