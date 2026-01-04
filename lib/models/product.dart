class ProductModel {
  final String id;
  final String name;
  final double price;
  final double? discountPrice;
  final List<String> imageUrls;
  final String description;
  final String categoryId;
  final int stockQuantity;
  final double averageRating;
  final int reviewCount;
  final String? brand;
  final String? servingSize;
  final int? servingsPerContainer;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.imageUrls,
    required this.description,
    required this.categoryId,
    this.stockQuantity = 0,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.brand,
    this.servingSize,
    this.servingsPerContainer,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      price: double.tryParse((json['price'] ?? 0).toString()) ?? 0.0,
      discountPrice: (json['discountPrice'] ?? json['discount_price']) != null 
          ? double.tryParse((json['discountPrice'] ?? json['discount_price']).toString()) 
          : null,
      imageUrls: List<String>.from(json['imageUrls'] ?? json['image_urls'] ?? []),
      description: (json['description'] ?? '').toString(),
      categoryId: (json['categoryId'] ?? json['category_id'] ?? '').toString(),
      stockQuantity: int.tryParse((json['stockQuantity'] ?? json['stock_quantity'] ?? 0).toString()) ?? 0,
      averageRating: double.tryParse((json['averageRating'] ?? json['average_rating'] ?? 0).toString()) ?? 0.0,
      reviewCount: int.tryParse((json['reviewCount'] ?? json['review_count'] ?? 0).toString()) ?? 0,
      brand: (json['brand'] ?? '').toString(),
      servingSize: (json['servingSize'] ?? json['serving_size'])?.toString(),
      servingsPerContainer: int.tryParse((json['servingsPerContainer'] ?? json['servings_per_container'] ?? 0).toString()),
      isActive: json['isActive'] == true || json['is_active'] == true || 
                json['isActive'] == 1 || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discount_price': discountPrice,
      'image_urls': imageUrls,
      'description': description,
      'category_id': categoryId,
      'stock_quantity': stockQuantity,
      'average_rating': averageRating,
      'review_count': reviewCount,
      'brand': brand,
      'serving_size': servingSize,
      'servings_per_container': servingsPerContainer,
      'is_active': isActive,
    };
  }

  double get discountPercentage {
    if (discountPrice != null && price > 0) {
      return ((price - discountPrice!) / price * 100).roundToDouble();
    }
    return 0;
  }
}