class ProductModel {
  // Basic Fields
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

  // Basic Info
  final String? sku;
  final List<String>? tags;
  final double? weight;
  final String? size;

  // Nutrition
  final Map<String, dynamic>? nutritionFacts;

  // Marketing
  final bool featured;
  final bool newArrival;
  final bool bestSeller;
  final int totalSales;
  final int viewsCount;

  // Shipping
  final double? shippingWeight;
  final Map<String, dynamic>? dimensions;

  // Additional
  final String? ingredients;
  final String? usageInstructions;
  final String? warnings;
  final DateTime? expiryDate;
  final String? manufacturer;
  final String? countryOfOrigin;

  // SEO
  final String? metaTitle;
  final String? metaDescription;
  final String? slug;

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
    // Basic Info
    this.sku,
    this.tags,
    this.weight,
    this.size,
    // Nutrition
    this.nutritionFacts,
    // Marketing
    this.featured = false,
    this.newArrival = false,
    this.bestSeller = false,
    this.totalSales = 0,
    this.viewsCount = 0,
    // Shipping
    this.shippingWeight,
    this.dimensions,
    // Additional
    this.ingredients,
    this.usageInstructions,
    this.warnings,
    this.expiryDate,
    this.manufacturer,
    this.countryOfOrigin,
    // SEO
    this.metaTitle,
    this.metaDescription,
    this.slug,
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
      brand: json['brand']?.toString(),
      servingSize: (json['servingSize'] ?? json['serving_size'])?.toString(),
      servingsPerContainer: int.tryParse((json['servingsPerContainer'] ?? json['servings_per_container'] ?? 0).toString()),
      isActive: json['isActive'] == true || json['is_active'] == true || 
                json['isActive'] == 1 || json['is_active'] == 1,
      // Basic Info
      sku: json['sku']?.toString(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      size: json['size']?.toString(),
      // Nutrition
      nutritionFacts: json['nutritionFacts'] ?? json['nutrition_facts'],
      // Marketing
      featured: json['featured'] == true || json['featured'] == 1,
      newArrival: json['newArrival'] == true || json['new_arrival'] == true || 
                  json['newArrival'] == 1 || json['new_arrival'] == 1,
      bestSeller: json['bestSeller'] == true || json['best_seller'] == true ||
                  json['bestSeller'] == 1 || json['best_seller'] == 1,
      totalSales: int.tryParse((json['totalSales'] ?? json['total_sales'] ?? 0).toString()) ?? 0,
      viewsCount: int.tryParse((json['viewsCount'] ?? json['views_count'] ?? 0).toString()) ?? 0,
      // Shipping
      shippingWeight: json['shippingWeight'] ?? json['shipping_weight'] != null 
          ? double.tryParse((json['shippingWeight'] ?? json['shipping_weight']).toString()) 
          : null,
      dimensions: json['dimensions'],
      // Additional
      ingredients: json['ingredients']?.toString(),
      usageInstructions: (json['usageInstructions'] ?? json['usage_instructions'])?.toString(),
      warnings: json['warnings']?.toString(),
      expiryDate: json['expiryDate'] ?? json['expiry_date'] != null 
          ? DateTime.tryParse((json['expiryDate'] ?? json['expiry_date']).toString())
          : null,
      manufacturer: json['manufacturer']?.toString(),
      countryOfOrigin: (json['countryOfOrigin'] ?? json['country_of_origin'])?.toString(),
      // SEO
      metaTitle: (json['metaTitle'] ?? json['meta_title'])?.toString(),
      metaDescription: (json['metaDescription'] ?? json['meta_description'])?.toString(),
      slug: json['slug']?.toString(),
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
      'is_active': isActive ? 1 : 0,
      // Basic Info
      'sku': sku,
      'tags': tags,
      'weight': weight,
      'size': size,
      // Nutrition
      'nutrition_facts': nutritionFacts,
      // Marketing
      'featured': featured ? 1 : 0,
      'new_arrival': newArrival ? 1 : 0,
      'best_seller': bestSeller ? 1 : 0,
      'total_sales': totalSales,
      'views_count': viewsCount,
      // Shipping
      'shipping_weight': shippingWeight,
      'dimensions': dimensions,
      // Additional
      'ingredients': ingredients,
      'usage_instructions': usageInstructions,
      'warnings': warnings,
      'expiry_date': expiryDate?.toIso8601String(),
      'manufacturer': manufacturer,
      'country_of_origin': countryOfOrigin,
      // SEO
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'slug': slug,
    };
  }

  // Getters
  double get discountPercentage {
    if (discountPrice != null && price > 0) {
      return ((price - discountPrice!) / price * 100).roundToDouble();
    }
    return 0;
  }

  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  bool get isInStock => stockQuantity > 0;

  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 10;

  double get finalPrice => discountPrice ?? price;

  String get displayPrice {
    if (hasDiscount) {
      return '${finalPrice.toStringAsFixed(2)} ر.س';
    }
    return '${price.toStringAsFixed(2)} ر.س';
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry > 0 && daysUntilExpiry <= 30;
  }
}