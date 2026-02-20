import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';

class ProductVariantManager extends StatelessWidget {
  final ProductsController controller;

  const ProductVariantManager({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تنويعات المنتج (SKUs)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.addVariant,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة تنويع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: Colors.white.withValues(alpha: 0.2), size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد تنويعات بعد. أضف واحداً لإدارة مخزون SKU.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.variants.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final variant = controller.variants[index];
                  return _VariantItemEditor(
                    index: index,
                    variant: variant,
                    onUpdate: (updated) => controller.updateVariant(index, updated),
                    onDelete: () => controller.removeVariant(index),
                    availableSizes: controller.productSizes.map((e) => e.size).toList(),
                    availableFlavors: controller.productFlavors,
                  );
                },
              ),
          ],
        ));
  }
}

class _VariantItemEditor extends StatefulWidget {
  final int index;
  final ProductVariantModel variant;
  final Function(ProductVariantModel) onUpdate;
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
    discountCtrl = TextEditingController(text: widget.variant.discountPrice?.toString() ?? '');
    stockCtrl = TextEditingController(text: widget.variant.stockQuantity.toString());
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
    final updated = widget.variant.copyWith(
      sku: skuCtrl.text,
      price: double.tryParse(priceCtrl.text) ?? 0.0,
      discountPrice: double.tryParse(discountCtrl.text),
      stockQuantity: int.tryParse(stockCtrl.text) ?? 0,
    );
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text('${widget.index + 1}', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              const Text('تنويع جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          const Text('السمات (Attributes)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildAttributeSelector('المقاس', widget.availableSizes, 'size'),
              _buildAttributeSelector('النكهة', widget.availableFlavors, 'flavor'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeSelector(String label, List<String> options, String key) {
    if (options.isEmpty) return const SizedBox.shrink();

    final currentVal = widget.variant.attributes[key];

    return PopupMenuButton<String>(
      onSelected: (val) {
        final newAttrs = Map<String, dynamic>.from(widget.variant.attributes);
        newAttrs[key] = val;
        widget.onUpdate(widget.variant.copyWith(attributes: newAttrs));
      },
      itemBuilder: (context) => options
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Text(opt),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentVal ?? '$label: اختر',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
