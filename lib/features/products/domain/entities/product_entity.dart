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
  final List<ProductSizeEntity>? productSizes;
  final List<String>? flavors;

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
    this.productSizes,
    this.flavors,
  });

  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;
  String getDescription(String lang) => lang == 'ar' ? descriptionAr : descriptionEn;
  
  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;
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
