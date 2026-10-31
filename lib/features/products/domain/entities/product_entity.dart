/// Pure Dart Domain Entity representing a Product.
/// 100% pure Dart - zero imports from external frameworks or storage packages.
class ProductEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final double? discountPrice;
  final List<String> imageUrls;
  final String categoryId;
  final int stockQuantity;
  final String? brand;
  final bool isActive;
  final bool isFeatured;
  final bool? isBackgroundWhite;
  final String? servingSize;
  final int? servingsPerContainer;
  final List<ProductSizeEntity>? productSizes;
  final List<String>? flavors;
  final List<ProductVariantEntity>? variants;

  String get displayName => nameAr;

  const ProductEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    this.discountPrice,
    required this.imageUrls,
    required this.categoryId,
    required this.stockQuantity,
    this.brand,
    required this.isActive,
    required this.isFeatured,
    this.isBackgroundWhite,
    this.servingSize,
    this.servingsPerContainer,
    this.productSizes,
    this.flavors,
    this.variants,
  });

  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;
  String getDescription(String lang) =>
      lang == 'ar' ? descriptionAr : descriptionEn;

  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;

  ProductEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    double? price,
    double? discountPrice,
    List<String>? imageUrls,
    String? categoryId,
    int? stockQuantity,
    String? brand,
    bool? isActive,
    bool? isFeatured,
    bool? isBackgroundWhite,
    String? servingSize,
    int? servingsPerContainer,
    List<ProductSizeEntity>? productSizes,
    List<String>? flavors,
    List<ProductVariantEntity>? variants,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      brand: brand ?? this.brand,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isBackgroundWhite: isBackgroundWhite ?? this.isBackgroundWhite,
      servingSize: servingSize ?? this.servingSize,
      servingsPerContainer: servingsPerContainer ?? this.servingsPerContainer,
      productSizes: productSizes ?? this.productSizes,
      flavors: flavors ?? this.flavors,
      variants: variants ?? this.variants,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameAr == other.nameAr &&
          nameEn == other.nameEn &&
          price == other.price &&
          categoryId == other.categoryId &&
          stockQuantity == other.stockQuantity &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      id.hashCode ^
      nameAr.hashCode ^
      nameEn.hashCode ^
      price.hashCode ^
      categoryId.hashCode ^
      stockQuantity.hashCode ^
      isActive.hashCode;

  @override
  String toString() =>
      'ProductEntity(id: $id, name: $nameAr, price: $price, stock: $stockQuantity)';
}

/// Pure Dart Domain Entity representing a Product Size variant.
class ProductSizeEntity {
  final String size;
  final double price;
  final double? discountPrice;
  final int? servings;
  final String? weight;
  final int? stockQuantity;

  const ProductSizeEntity({
    required this.size,
    required this.price,
    this.discountPrice,
    this.servings,
    this.weight,
    this.stockQuantity,
  });

  ProductSizeEntity copyWith({
    String? size,
    double? price,
    double? discountPrice,
    int? servings,
    String? weight,
    int? stockQuantity,
  }) {
    return ProductSizeEntity(
      size: size ?? this.size,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      servings: servings ?? this.servings,
      weight: weight ?? this.weight,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeEntity &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          price == other.price &&
          discountPrice == other.discountPrice &&
          servings == other.servings &&
          weight == other.weight &&
          stockQuantity == other.stockQuantity;

  @override
  int get hashCode =>
      size.hashCode ^
      price.hashCode ^
      discountPrice.hashCode ^
      servings.hashCode ^
      weight.hashCode ^
      stockQuantity.hashCode;

  @override
  String toString() =>
      'ProductSizeEntity(size: $size, price: $price, discountPrice: $discountPrice, servings: $servings, weight: $weight, stock: $stockQuantity)';
}

/// Pure Dart Domain Entity representing an advanced Product Variant.
class ProductVariantEntity {
  final String id;
  final String sku;
  final double price;
  final double? discountPrice;
  final double effectivePrice;
  final int stockQuantity;
  final Map<String, dynamic> attributes;
  final bool isActive;

  const ProductVariantEntity({
    required this.id,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.effectivePrice,
    required this.stockQuantity,
    required this.attributes,
    required this.isActive,
  });

  ProductVariantEntity copyWith({
    String? id,
    String? sku,
    double? price,
    double? discountPrice,
    double? effectivePrice,
    int? stockQuantity,
    Map<String, dynamic>? attributes,
    bool? isActive,
  }) {
    return ProductVariantEntity(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      effectivePrice: effectivePrice ?? this.effectivePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      attributes: attributes ?? this.attributes,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sku == other.sku &&
          price == other.price &&
          effectivePrice == other.effectivePrice &&
          stockQuantity == other.stockQuantity &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      id.hashCode ^
      sku.hashCode ^
      price.hashCode ^
      effectivePrice.hashCode ^
      stockQuantity.hashCode ^
      isActive.hashCode;

  @override
  String toString() =>
      'ProductVariantEntity(id: $id, sku: $sku, price: $price)';
}
