import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    required super.price,
    super.discountPrice,
    required super.imageUrls,
    required super.categoryId,
    required super.stockQuantity,
    super.brand,
    required super.isActive,
    super.productSizes,
    super.flavors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse translatable strings
    String parseAr(dynamic val) {
      if (val is Map) return val['ar']?.toString() ?? '';
      return val?.toString() ?? '';
    }

    String parseEn(dynamic val) {
      if (val is Map) return val['en']?.toString() ?? '';
      return '';
    }

    final imageUrlsRaw = json['imageUrls'] ?? json['image_urls'] ?? [];
    final List<String> imageUrls = (imageUrlsRaw as List).map((e) {
      if (e is Map) return (e['original'] ?? e['thumbnail'] ?? '').toString();
      return e.toString();
    }).toList();

    final productSizesRaw = json['product_sizes'] ?? [];
    final List<ProductSizeEntity> productSizes = (productSizesRaw as List).map((e) {
      return ProductSizeEntity(
        size: e['size']?.toString() ?? '',
        price: (e['price'] as num?)?.toDouble() ?? 0.0,
        discountPrice: (e['discount_price'] as num?)?.toDouble(),
      );
    }).toList();

    return ProductModel(
      id: json['id']?.toString() ?? '',
      nameAr: parseAr(json['name']),
      nameEn: parseEn(json['name']),
      descriptionAr: parseAr(json['description']),
      descriptionEn: parseEn(json['description']),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls: imageUrls,
      categoryId: (json['category_id'] ?? json['categoryId'] ?? '').toString(),
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      brand: json['brand']?.toString(),
      isActive: json['is_active'] ?? true,
      productSizes: productSizes,
      flavors: (json['flavors'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': {'ar': nameAr, 'en': nameEn},
      'description': {'ar': descriptionAr, 'en': nameEn},
      'price': price,
      'discount_price': discountPrice,
      'image_urls': imageUrls,
      'category_id': categoryId,
      'stock_quantity': stockQuantity,
      'brand': brand,
      'is_active': isActive,
      'flavors': flavors,
      'product_sizes': productSizes
          ?.map((s) => {
                'size': s.size,
                'price': s.price,
                'discount_price': s.discountPrice,
              })
          .toList(),
    };
  }
}
