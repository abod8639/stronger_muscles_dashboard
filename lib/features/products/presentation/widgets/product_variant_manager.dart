import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
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

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تنويعات المنتج (SKUs)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (controller.variants.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${controller.variants.length} تنويع',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Auto-generate Matrix Button
                  if (controller.productSizes.isNotEmpty ||
                      controller.productFlavors.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: controller.generateVariantsMatrix,
                        icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                        label: const Text(
                          'توليد المصفوفة تلقائياً',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Bulk Edit Button
                  if (controller.variants.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                        ),
                        onPressed: () => _showBulkEditDialog(context, controller),
                        icon: const Icon(Icons.edit_note_rounded, size: 16),
                        label: const Text(
                          'تعديل جماعي',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Neumorphic Add Variant Button
                  Container(
                    decoration: AppDesignTokens.softSurface(
                      colorScheme,
                      isDark: isDark,
                      borderRadius: BorderRadius.circular(10),
                      compact: true,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: controller.addNewVariant,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 17,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'تنويع يدوي',
                                style: TextStyle(
                                  fontSize: 12,
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
            ],
          ),
          const SizedBox(height: 12),
          if (controller.variants.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: AppDesignTokens.softSurface(
                colorScheme,
                isDark: isDark,
                borderRadius: BorderRadius.circular(16),
                compact: true,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد تنويعات بعد.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'حدّد الأحجام والنكهات أعلاه ثم اضغط "توليد المصفوفة تلقائياً" لإنشاء تركيبة SKUs بأسعار ومخزون منفصل لكل نكهة ووزن.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
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
                  key: ValueKey(variant.id),
                  index: index,
                  variant: variant,
                  onUpdate: (updated) =>
                      controller.updateVariant(index, updated, notify: false),
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

  void _showBulkEditDialog(BuildContext context, ProductsController controller) {
    final priceCtrl = TextEditingController();
    final discountCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.tune_rounded, size: 20),
            SizedBox(width: 8),
            Text('تعديل جماعي للتنويعات'),
          ],
        ),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم تطبيق القيم المدخلة أدناه على جميع التنويعات (${controller.variants.length} تنويع). اترك الحقل فارغاً إذا كنت لا ترغب بتغيير قيمته الحالية.',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'السعر الموحد لجميع التنويعات',
                  hintText: 'اتركه فارغاً للإبقاء على السعر الحالي',
                  prefixIcon: Icon(Icons.price_change_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: discountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'سعر الخصم الموحد',
                  hintText: 'اختياري',
                  prefixIcon: Icon(Icons.sell_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الكمية في المخزن لكل تنويع',
                  hintText: 'مثال: 25',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final price = double.tryParse(priceCtrl.text.trim());
              final discount = double.tryParse(discountCtrl.text.trim());
              final stock = int.tryParse(stockCtrl.text.trim());

              controller.bulkUpdateVariants(
                price: price,
                discountPrice: discount,
                stockQuantity: stock,
              );
              Navigator.of(ctx).pop();
            },
            child: const Text('تطبيق التعديلات'),
          ),
        ],
      ),
    );
  }
}

class _VariantItemEditor extends ConsumerStatefulWidget {
  final int index;
  final ProductVariantEntity variant;
  final Function(ProductVariantEntity) onUpdate;
  final VoidCallback onDelete;
  final List<String> availableSizes;
  final List<String> availableFlavors;

  const _VariantItemEditor({
    super.key,
    required this.index,
    required this.variant,
    required this.onUpdate,
    required this.onDelete,
    required this.availableSizes,
    required this.availableFlavors,
  });

  @override
  ConsumerState<_VariantItemEditor> createState() => _VariantItemEditorState();
}

class _VariantItemEditorState extends ConsumerState<_VariantItemEditor> {
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
  void didUpdateWidget(covariant _VariantItemEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variant.sku != widget.variant.sku &&
        skuCtrl.text != widget.variant.sku) {
      skuCtrl.text = widget.variant.sku;
    }
    if (oldWidget.variant.price != widget.variant.price &&
        priceCtrl.text != widget.variant.price.toString()) {
      priceCtrl.text = widget.variant.price.toString();
    }
    final nextDiscount = widget.variant.discountPrice?.toString() ?? '';
    if (oldWidget.variant.discountPrice != widget.variant.discountPrice &&
        discountCtrl.text != nextDiscount) {
      discountCtrl.text = nextDiscount;
    }
    final nextStock = widget.variant.stockQuantity.toString();
    if (oldWidget.variant.stockQuantity != widget.variant.stockQuantity &&
        stockCtrl.text != nextStock) {
      stockCtrl.text = nextStock;
    }
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
    final price = double.tryParse(priceCtrl.text) ?? 0.0;
    final discount = double.tryParse(discountCtrl.text);
    final effectivePrice =
        (discount != null && discount > 0) ? discount : price;

    final updated = widget.variant.copyWith(
      sku: skuCtrl.text.trim(),
      price: price,
      discountPrice: discount,
      effectivePrice: effectivePrice,
      stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
    );
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(storeCurrencyProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(16),
        compact: true,
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
                              Color.lerp(
                                colorScheme.primaryContainer,
                                Colors.white,
                                0.02,
                              )!,
                              Color.lerp(
                                colorScheme.surfaceContainer,
                                colorScheme.primary,
                                0.10,
                              )!,
                            ]
                          : [
                              Color.lerp(
                                colorScheme.primaryContainer,
                                Colors.white,
                                0.40,
                              )!,
                              Color.lerp(
                                colorScheme.primaryContainer,
                                Colors.black,
                                0.02,
                              )!,
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
                      color: colorScheme.primary.withValues(
                        alpha: isDark ? 0.5 : 0.6,
                      ),
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
                  decoration: AppDesignTokens.softSurface(
                    colorScheme,
                    isDark: isDark,
                    borderRadius: BorderRadius.circular(8),
                    compact: true,
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
                    suffixText: currency,
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
                    suffixText: currency,
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
                _buildAttributeSelector(
                  context,
                  'المقاس',
                  widget.availableSizes,
                  'size',
                  colorScheme,
                  isDark,
                ),
                _buildAttributeSelector(
                  context,
                  'النكهة',
                  widget.availableFlavors,
                  'flavor',
                  colorScheme,
                  isDark,
                ),
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
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
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
        widget.onUpdate(
          widget.variant.copyWith(attributes: newAttrs),
        );
      },
      itemBuilder: (context) => options
          .map((opt) {
            final displayName =
                opt.contains('|') ? opt.split('|').first.trim() : opt;
            return PopupMenuItem(
              value: displayName,
              child: Text(displayName),
            );
          })
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: AppDesignTokens.softSurface(
          colorScheme,
          isDark: isDark,
          borderRadius: BorderRadius.circular(8),
          compact: true,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: hasVal
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              currentVal ?? '$label: اختر',
              style: TextStyle(
                fontSize: 12,
                fontWeight: hasVal ? FontWeight.bold : FontWeight.w500,
                color: hasVal
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
