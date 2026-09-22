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
  String getDescription(String lang) => lang == 'ar' ? descriptionAr : descriptionEn;
  
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
}

class ProductSizeEntity {
  final String size;
  final double price;
  final double? discountPrice;

  const ProductSizeEntity({
    required this.size,
    required this.price,
    this.discountPrice,
  });
}

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
}
