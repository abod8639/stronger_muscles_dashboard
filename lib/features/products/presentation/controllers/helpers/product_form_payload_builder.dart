import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// Pure builder responsible for assembling the product payload map for creation/updates.
/// Isolates data transformation and validation rules from presentation controllers.
class ProductFormPayloadBuilder {
  const ProductFormPayloadBuilder._();

  /// Compiles all form inputs, size models, and variant definitions into an API-ready payload.
  static Map<String, dynamic> build({
    required ProductEntity? existingProduct,
    required String categoryId,
    required List<String> productImages,
    required Map<String, TextEditingController> textControllers,
    required List<ProductSizeEntity> productSizes,
    required Map<String, TextEditingController> sizePriceControllers,
    required Map<String, TextEditingController> sizeDiscountControllers,
    required Map<String, TextEditingController> sizeServingsControllers,
    required Map<String, TextEditingController> sizeWeightControllers,
    required Map<String, TextEditingController> sizeStockControllers,
    required List<ProductVariantEntity> variants,
    required List<String> productFlavors,
    required List<String> tags,
    required List<String> allergens,
    required bool isActive,
    required bool isFeatured,
    required bool newArrival,
    required bool bestSeller,
    required bool isBackgroundWhite,
    String? matchedBrandId,
  }) {
    // 1. Sync & Map Product Sizes with current controller values
    final updatedSizes = productSizes.map((ps) {
      final price =
          double.tryParse(sizePriceControllers[ps.size]?.text ?? '0') ?? 0.0;
      final discount = double.tryParse(
        sizeDiscountControllers[ps.size]?.text ?? '',
      );
      final servings =
          int.tryParse(sizeServingsControllers[ps.size]?.text.trim() ?? '');
      final weight = sizeWeightControllers[ps.size]?.text.trim();
      final stock =
          int.tryParse(sizeStockControllers[ps.size]?.text.trim() ?? '');
      return ProductSizeEntity(
        size: ps.size,
        price: price,
        discountPrice: discount,
        servings: servings,
        weight: (weight != null && weight.isNotEmpty) ? weight : null,
        stockQuantity: stock,
        flavors: ps.flavors,
      );
    }).toList();

    // 2. Compute Unified Stock
    int totalStock =
        int.tryParse(textControllers['stock']?.text.trim() ?? '0') ?? 0;
    if (variants.isNotEmpty) {
      final sumVariantsStock = variants.fold<int>(
        0,
        (sum, v) => sum + v.stockQuantity,
      );
      if (sumVariantsStock > 0 || totalStock == 0) {
        totalStock = sumVariantsStock;
      }
    } else if (totalStock == 0 && updatedSizes.isNotEmpty) {
      int sumSizesStock = 0;
      for (final s in updatedSizes) {
        if (s.stockQuantity != null) {
          sumSizesStock += s.stockQuantity!;
        }
      }
      if (sumSizesStock > 0) {
        totalStock = sumSizesStock;
      }
    }

    // 3. Compute Main Price and Fallbacks
    double mainPrice =
        double.tryParse(textControllers['price']?.text ?? '0') ?? 0.0;
    double? discountPrice =
        double.tryParse(textControllers['discount']?.text ?? '');

    if (mainPrice == 0 && updatedSizes.isNotEmpty) {
      mainPrice = updatedSizes.first.price;
      discountPrice = updatedSizes.first.discountPrice;
    }

    final String generatedId =
        existingProduct?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}';

    final nameAr = textControllers['name_ar']?.text.trim() ?? '';
    final nameEn = textControllers['name_en']?.text.trim() ?? '';
    final finalNameEn = nameEn.isNotEmpty ? nameEn : nameAr;

    final descAr = textControllers['desc_ar']?.text.trim() ?? '';
    final descEn = textControllers['desc_en']?.text.trim() ?? '';
    final finalDescEn = descEn.isNotEmpty ? descEn : descAr;

    final enteredBrand = textControllers['brand']?.text.trim() ?? '';

    // 4. Build Nutrition Facts
    final nutritionFacts = <String, dynamic>{
      if (textControllers['calories']?.text.trim().isNotEmpty == true)
        'calories': textControllers['calories']!.text.trim(),
      if (textControllers['protein']?.text.trim().isNotEmpty == true)
        'protein': textControllers['protein']!.text.trim(),
      if (textControllers['carbs']?.text.trim().isNotEmpty == true)
        'carbs': textControllers['carbs']!.text.trim(),
      if (textControllers['fat']?.text.trim().isNotEmpty == true)
        'fat': textControllers['fat']!.text.trim(),
      if (textControllers['sugar']?.text.trim().isNotEmpty == true)
        'sugar': textControllers['sugar']!.text.trim(),
      if (allergens.isNotEmpty) 'allergens': allergens.toList(),
    };

    // 5. Serving calculations
    final servingSize = textControllers['serving']?.text.trim().isNotEmpty ==
            true
        ? textControllers['serving']!.text.trim()
        : (updatedSizes.isNotEmpty &&
                (updatedSizes.first.weight?.isNotEmpty ?? false)
            ? updatedSizes.first.weight!
            : '');

    final int rawSessions =
        int.tryParse(textControllers['sessions']?.text.trim() ?? '') ?? 0;
    final servingsPerContainer = rawSessions > 0
        ? rawSessions
        : (updatedSizes.isNotEmpty && updatedSizes.first.servings != null
            ? updatedSizes.first.servings!
            : 0);

    final skuText = textControllers['sku']?.text.trim();
    final manufacturerUrl = textControllers['manufacturer_url']?.text.trim();

    return {
      'id': generatedId,
      'name': {
        'ar': nameAr,
        'en': finalNameEn,
      },
      'description': {
        'ar': descAr,
        'en': finalDescEn,
      },
      'price': mainPrice,
      'discount_price': discountPrice,
      'image_urls': productImages,
      'category_id': categoryId,
      'stock_quantity': totalStock,
      'brand': enteredBrand,
      'brand_id': ?matchedBrandId,
      'sku': (skuText != null && skuText.isNotEmpty) ? skuText : null,
      if (manufacturerUrl != null && manufacturerUrl.isNotEmpty)
        'manufacturer_url': manufacturerUrl,
      'tags': tags.toList(),
      'nutrition_facts': nutritionFacts.isNotEmpty ? nutritionFacts : null,
      'is_active': isActive,
      'featured': isFeatured,
      'new_arrival': newArrival,
      'best_seller': bestSeller,
      'is_background_white': isBackgroundWhite,
      'serving_size': servingSize,
      'servings_per_container': servingsPerContainer,
      'flavors': productFlavors.toList(),
      'product_sizes': updatedSizes
          .map(
            (s) => {
              'size': s.size,
              'price': s.price,
              'discount_price': s.discountPrice,
              if (s.servings != null) 'servings': s.servings,
              if (s.servings != null) 'servings_per_container': s.servings,
              if (s.weight != null) 'weight': s.weight,
              if (s.weight != null) 'serving_size': s.weight,
              if (s.stockQuantity != null) 'stock_quantity': s.stockQuantity,
              if (s.stockQuantity != null) 'stock': s.stockQuantity,
              if (s.flavors != null) 'flavors': s.flavors,
            },
          )
          .toList(),
      'product_variants': variants
          .map(
            (v) => {
              'id': v.id,
              'sku': v.sku,
              'price': v.price,
              'discount_price': v.discountPrice,
              'effective_price': v.effectivePrice,
              'stock_quantity': v.stockQuantity,
              'attributes': v.attributes,
              'is_active': v.isActive,
              if (v.barcode != null && v.barcode!.isNotEmpty)
                'barcode': v.barcode,
            },
          )
          .toList(),
    };
  }
}
