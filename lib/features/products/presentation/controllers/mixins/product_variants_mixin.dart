import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import '../helpers/product_sku_generator.dart';
import 'product_form_fields_mixin.dart';
import 'product_sizes_mixin.dart';

/// Mixin managing product variants (SKUs) and automatic SKU matrix generation.
mixin ProductVariantsMixin on ChangeNotifier, ProductFormFieldsMixin, ProductSizesMixin {
  final List<ProductVariantEntity> variants = [];

  int get totalVariantsStock {
    int sum = 0;
    for (var v in variants) {
      sum += v.stockQuantity;
    }
    return sum;
  }

  void addNewVariant() {
    final newVariant = ProductVariantEntity(
      id: 'VAR-${DateTime.now().millisecondsSinceEpoch}',
      sku: 'SKU-${DateTime.now().millisecondsSinceEpoch % 10000}',
      price: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      discountPrice: double.tryParse(textcontrollers['discount']?.text ?? ''),
      effectivePrice:
          double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      stockQuantity: int.tryParse(textcontrollers['stock']?.text ?? '0') ?? 0,
      attributes: const {},
      isActive: true,
    );
    variants.add(newVariant);
    markFormDirty();
    notifyListeners();
  }

  void addVariant(ProductVariantEntity variant) {
    variants.add(variant);
    markFormDirty();
    notifyListeners();
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
      markFormDirty();
      notifyListeners();
    }
  }

  void updateVariant(
    int index,
    ProductVariantEntity updated, {
    bool notify = true,
  }) {
    if (index >= 0 && index < variants.length) {
      variants[index] = updated;
      markFormDirty();
      if (notify) {
        notifyListeners();
      }
    }
  }

  /// Automatically generates the SKU matrix from the Cartesian product of sizes and flavors
  void generateVariantsMatrix() {
    if (productSizes.isEmpty && productFlavors.isEmpty) {
      AppFeedback.showWarning(
        'يرجى تحديد الأحجام أو النكهات أولاً لتوليد مصفوفة التنويعات',
      );
      return;
    }

    variants.clear();
    markFormDirty();

    final generated = ProductSkuGenerator.generateMatrix(
      rawBaseSku: textcontrollers['sku']?.text.trim() ?? '',
      basePrice: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      baseDiscount: double.tryParse(textcontrollers['discount']?.text ?? ''),
      sizes: productSizes,
      globalFlavors: productFlavors,
      resolveSizePrice: (size, fallback) =>
          double.tryParse(sizePriceControllers[size]?.text ?? '') ?? fallback,
      resolveSizeDiscount: (size, fallback) =>
          double.tryParse(sizeDiscountControllers[size]?.text ?? '') ??
          fallback,
      resolveSizeStock: (size, fallback) =>
          int.tryParse(sizeStockControllers[size]?.text ?? '') ??
          fallback ??
          0,
    );

    variants.addAll(generated);
    notifyListeners();
    AppFeedback.showSuccess(
      'تم توليد ${variants.length} تنويع (SKU) تلقائياً بنجاح',
    );
  }

  /// Applies bulk changes across all variants (unified price, discount, or stock)
  void bulkUpdateVariants({
    double? price,
    double? discountPrice,
    int? stockQuantity,
  }) {
    if (variants.isEmpty) return;
    for (int i = 0; i < variants.length; i++) {
      final v = variants[i];
      final newPrice = price ?? v.price;
      final newDiscount = discountPrice ?? v.discountPrice;
      final newStock = stockQuantity ?? v.stockQuantity;
      final effective = (newDiscount != null && newDiscount > 0)
          ? newDiscount
          : newPrice;

      variants[i] = v.copyWith(
        price: newPrice,
        discountPrice: newDiscount,
        effectivePrice: effective,
        stockQuantity: newStock,
      );
    }
    markFormDirty();
    notifyListeners();
    AppFeedback.showSuccess('تم تطبيق التعديلات على كافة التنويعات بنجاح');
  }

  void initVariantsForProduct(ProductEntity? product) {
    variants.clear();
    if (product != null && product.variants != null) {
      variants.addAll(product.variants!);
    }
  }

  void clearVariants() {
    variants.clear();
  }
}
