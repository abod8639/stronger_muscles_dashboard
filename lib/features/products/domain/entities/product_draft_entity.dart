import 'product_entity.dart';

/// Pure Dart Domain Entity representing a saved product draft.
/// 100% decoupled from Flutter UI, Hive, Dio, or 3rd-party persistence SDKs.
class ProductDraftEntity {
  final String id;
  final String title;
  final DateTime updatedAt;
  final String? existingProductId;
  final String? categoryId;
  final Map<String, String> formFields;
  final List<String> imageUrls;
  final List<ProductSizeEntity> productSizes;
  final Map<String, Map<String, String>> sizeControllerValues;
  final List<ProductVariantEntity> variants;
  final List<String> productFlavors;
  final List<String> tags;
  final List<String> allergens;
  final bool isActive;
  final bool isFeatured;
  final bool newArrival;
  final bool bestSeller;
  final bool isBackgroundWhite;

  const ProductDraftEntity({
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

  ProductDraftEntity copyWith({
    String? id,
    String? title,
    DateTime? updatedAt,
    String? existingProductId,
    String? categoryId,
    Map<String, String>? formFields,
    List<String>? imageUrls,
    List<ProductSizeEntity>? productSizes,
    Map<String, Map<String, String>>? sizeControllerValues,
    List<ProductVariantEntity>? variants,
    List<String>? productFlavors,
    List<String>? tags,
    List<String>? allergens,
    bool? isActive,
    bool? isFeatured,
    bool? newArrival,
    bool? bestSeller,
    bool? isBackgroundWhite,
  }) {
    return ProductDraftEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      existingProductId: existingProductId ?? this.existingProductId,
      categoryId: categoryId ?? this.categoryId,
      formFields: formFields ?? this.formFields,
      imageUrls: imageUrls ?? this.imageUrls,
      productSizes: productSizes ?? this.productSizes,
      sizeControllerValues: sizeControllerValues ?? this.sizeControllerValues,
      variants: variants ?? this.variants,
      productFlavors: productFlavors ?? this.productFlavors,
      tags: tags ?? this.tags,
      allergens: allergens ?? this.allergens,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      newArrival: newArrival ?? this.newArrival,
      bestSeller: bestSeller ?? this.bestSeller,
      isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDraftEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

