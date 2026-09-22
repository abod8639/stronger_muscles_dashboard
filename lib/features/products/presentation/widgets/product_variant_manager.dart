import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

class ProductVariantManager extends StatelessWidget {
  final ProductsController controller;

  const ProductVariantManager({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                ),
              ),
              FilledButton.icon(
                onPressed: controller.addVariant,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إضافة تنويع'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.variants.isEmpty)
            Card.outlined(
              margin: EdgeInsets.zero,
              color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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

    return Card.outlined(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    '${widget.index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'تنويع ${widget.index + 1}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  tooltip: 'حذف التنويع',
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildModernTextField(
                    skuCtrl,
                    'رقم SKU',
                    Icons.qr_code_scanner,
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildModernTextField(
                    stockCtrl,
                    'المخزون',
                    Icons.inventory_2_outlined,
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
                  child: buildModernTextField(
                    priceCtrl,
                    'السعر',
                    Icons.payments_outlined,
                    isNumber: true,
                    onChanged: (_) => _triggerUpdate(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: buildModernTextField(
                    discountCtrl,
                    'الخصم',
                    Icons.sell_outlined,
                    isNumber: true,
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
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAttributeSelector(context, 'المقاس', widget.availableSizes, 'size'),
                _buildAttributeSelector(context, 'النكهة', widget.availableFlavors, 'flavor'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeSelector(
    BuildContext context,
    String label,
    List<String> options,
    String key,
  ) {
    if (options.isEmpty) return const SizedBox.shrink();

    final currentVal = widget.variant.attributes[key];

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
      child: ActionChip(
        avatar: const Icon(Icons.arrow_drop_down, size: 18),
        label: Text(currentVal ?? '$label: اختر'),
        onPressed: null, //handled by PopupMenuButton child
      ),
    );
  }
}
