import '../../domain/entities/product_draft_entity.dart';
import '../../domain/entities/product_entity.dart';

/// Data model representing a serialized product draft with JSON conversion and entity mapping.
class ProductDraftModel {
  final String id;
  final String title;
  final DateTime updatedAt;
  final String? existingProductId;
  final String? categoryId;
  final Map<String, String> formFields;
  final List<String> imageUrls;
  final List<Map<String, dynamic>> productSizes;
  final Map<String, Map<String, String>> sizeControllerValues;
  final List<Map<String, dynamic>> variants;
  final List<String> productFlavors;
  final List<String> tags;
  final List<String> allergens;
  final bool isActive;
  final bool isFeatured;
  final bool newArrival;
  final bool bestSeller;
  final bool isBackgroundWhite;

  const ProductDraftModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.existingProductId,
    this.categoryId,
    this.formFields = const {},
    this.imageUrls = const [],
    this.productSizes = const [],
    this.sizeControllerValues = const {},
    this.variants = const [],
    this.productFlavors = const [],
    this.tags = const [],
    this.allergens = const [],
    this.isActive = true,
    this.isFeatured = false,
    this.newArrival = false,
    this.bestSeller = false,
    this.isBackgroundWhite = true,
  });

  factory ProductDraftModel.fromEntity(ProductDraftEntity entity) {
    return ProductDraftModel(
      id: entity.id,
      title: entity.title,
      updatedAt: entity.updatedAt,
      existingProductId: entity.existingProductId,
      categoryId: entity.categoryId,
      formFields: Map<String, String>.from(entity.formFields),
      imageUrls: List<String>.from(entity.imageUrls),
      productSizes: entity.productSizes
          .map(
            (s) => {
              'size': s.size,
              'price': s.price,
              'discount_price': s.discountPrice,
              'servings': s.servings,
              'weight': s.weight,
              'stock_quantity': s.stockQuantity,
              'flavors': s.flavors,
            },
          )
          .toList(),
      sizeControllerValues: entity.sizeControllerValues.map(
        (k, v) => MapEntry(k, Map<String, String>.from(v)),
      ),
      variants: entity.variants
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
              'barcode': v.barcode,
            },
          )
          .toList(),
      productFlavors: List<String>.from(entity.productFlavors),
      tags: List<String>.from(entity.tags),
      allergens: List<String>.from(entity.allergens),
      isActive: entity.isActive,
      isFeatured: entity.isFeatured,
      newArrival: entity.newArrival,
      bestSeller: entity.bestSeller,
      isBackgroundWhite: entity.isBackgroundWhite,
    );
  }

  ProductDraftEntity toEntity() {
    return ProductDraftEntity(
      id: id,
      title: title,
      updatedAt: updatedAt,
      existingProductId: existingProductId,
      categoryId: categoryId,
      formFields: formFields,
      imageUrls: imageUrls,
      productSizes: productSizes.map((m) {
        return ProductSizeEntity(
          size: m['size']?.toString() ?? '',
          price: (m['price'] as num?)?.toDouble() ?? 0.0,
          discountPrice: (m['discount_price'] as num?)?.toDouble(),
          servings: (m['servings'] as num?)?.toInt(),
          weight: m['weight']?.toString(),
          stockQuantity: (m['stock_quantity'] as num?)?.toInt(),
          flavors: (m['flavors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
        );
      }).toList(),
      sizeControllerValues: sizeControllerValues,
      variants: variants.map((v) {
        return ProductVariantEntity(
          id: v['id']?.toString() ?? '',
          sku: v['sku']?.toString() ?? '',
          price: (v['price'] as num?)?.toDouble() ?? 0.0,
          discountPrice: (v['discount_price'] as num?)?.toDouble(),
          effectivePrice: (v['effective_price'] as num?)?.toDouble() ??
              (v['price'] as num?)?.toDouble() ??
              0.0,
          stockQuantity: (v['stock_quantity'] as num?)?.toInt() ?? 0,
          attributes: (v['attributes'] as Map<dynamic, dynamic>?)?.map(
                (k, val) => MapEntry(k.toString(), val),
              ) ??
              const {},
          isActive: v['is_active'] == true || v['is_active'] == 1,
          barcode: v['barcode']?.toString(),
        );
      }).toList(),
      productFlavors: productFlavors,
      tags: tags,
      allergens: allergens,
      isActive: isActive,
      isFeatured: isFeatured,
      newArrival: newArrival,
      bestSeller: bestSeller,
      isBackgroundWhite: isBackgroundWhite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'updated_at': updatedAt.toIso8601String(),
      'existing_product_id': existingProductId,
      'category_id': categoryId,
      'form_fields': formFields,
      'image_urls': imageUrls,
      'product_sizes': productSizes,
      'size_controller_values': sizeControllerValues,
      'variants': variants,
      'product_flavors': productFlavors,
      'tags': tags,
      'allergens': allergens,
      'is_active': isActive,
      'is_featured': isFeatured,
      'new_arrival': newArrival,
      'best_seller': bestSeller,
      'is_background_white': isBackgroundWhite,
    };
  }

  factory ProductDraftModel.fromJson(Map<String, dynamic> json) {
    return ProductDraftModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'مسودة بدون عنوان',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      existingProductId: json['existing_product_id']?.toString(),
      categoryId: json['category_id']?.toString(),
      formFields: (json['form_fields'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
          ) ??
          const {},
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      productSizes: (json['product_sizes'] as List<dynamic>?)
              ?.filter((e) => e is Map)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
      sizeControllerValues:
          (json['size_controller_values'] as Map<dynamic, dynamic>?)?.map(
                (k, v) => MapEntry(
                  k.toString(),
                  (v as Map<dynamic, dynamic>).map(
                    (ik, iv) => MapEntry(ik.toString(), iv?.toString() ?? ''),
                  ),
                ),
              ) ??
              const {},
      variants: (json['variants'] as List<dynamic>?)
              ?.filter((e) => e is Map)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
      productFlavors: (json['product_flavors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      newArrival: json['new_arrival'] ?? false,
      bestSeller: json['best_seller'] ?? false,
      isBackgroundWhite: json['is_background_white'] ?? true,
    );
  }
}

extension _IterableFilter<T> on Iterable<T> {
  Iterable<T> filter(bool Function(T) test) sync* {
    for (final element in this) {
      if (test(element)) yield element;
    }
  }
}
