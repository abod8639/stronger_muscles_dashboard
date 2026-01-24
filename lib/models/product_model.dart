import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 8) // تأكد من أن هذا الـ ID فريد في مشروعك
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double price,
    @HiveField(3) double? discountPrice,
    @HiveField(4) @Default([]) List<String> imageUrls,
    @HiveField(5) required String description,
    @HiveField(6) required String categoryId,
    @HiveField(7) @Default(0) int stockQuantity,
    @HiveField(8) @Default(0.0) double averageRating,
    @HiveField(9) @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) String? servingSize,
    @HiveField(12) int? servingsPerContainer,
    @HiveField(13) @Default(true) bool isActive,
    @HiveField(14) @Default(false) bool? isBackgroundWhite,

    @HiveField(15) String? sku,
    @HiveField(16) @Default([]) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) @Default([]) List<String>? size,
    @HiveField(19) @Default([]) List<String>? flavor,
    @HiveField(20) Map<String, dynamic>? nutritionFacts,

    @HiveField(21) @Default(false) bool featured,
    @HiveField(22) @Default(false) bool newArrival,
    @HiveField(23) @Default(false) bool bestSeller,
    @HiveField(24) @Default(0) int totalSales,
    @HiveField(25) @Default(0) int viewsCount,

    @HiveField(26) double? shippingWeight,
    @HiveField(27) Map<String, dynamic>? dimensions,

    @HiveField(28) @Default([]) List<String> ingredients,
    @HiveField(29) String? usageInstructions,
    @HiveField(30) String? warnings,
    @HiveField(31) DateTime? expiryDate,
    @HiveField(32) String? manufacturer,
    @HiveField(33) String? countryOfOrigin,

    @HiveField(34) String? metaTitle,
    @HiveField(35) String? metaDescription,
    @HiveField(36) String? slug,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => 
      _$ProductModelFromJson(_mapProductJson(json));

  // Getters
  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;
}

// --- دالة المعالجة لتنظيف البيانات القادمة من السيرفر ---
Map<String, dynamic> _mapProductJson(Map<String, dynamic> json) {
  List<String> toList(dynamic val) {
    if (val == null) return [];
    if (val is List) return val.map((e) => e.toString()).toList();
    if (val is String && val.isNotEmpty) {
      return val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  String toStringSafe(dynamic val) {
    if (val == null) return '';
    if (val is List) return val.isNotEmpty ? val.first.toString() : '';
    return val.toString();
  }

  return {
    ...json,
    'id': toStringSafe(json['id']),
    'name': toStringSafe(json['name']),
    'description': toStringSafe(json['description']),
    'category_id': toStringSafe(json['category_id'] ?? json['categoryId']),
    'brand': toStringSafe(json['brand']),
    'serving_size': toStringSafe(json['serving_size'] ?? json['servingSize']),
    'image_urls': toList(json['image_urls'] ?? json['imageUrls']),
    'flavors': toList(json['flavors'] ?? json['flavor']),
    'size': toList(json['size']),
    'price': double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    'discount_price': (json['discount_price'] != null || json['discountPrice'] != null)
        ? double.tryParse((json['discount_price'] ?? json['discountPrice']).toString()) 
        : null,
    'stock_quantity': int.tryParse((json['stock_quantity'] ?? json['stockQuantity'] ?? 0).toString()) ?? 0,
    'is_active': json['is_active'] == true || json['is_active'] == 1 || json['isActive'] == true,
    'ingredients': toList(json['ingredients']),
    'usage_instructions': toStringSafe(json['usage_instructions'] ?? json['usageInstructions']),
    'warnings': toStringSafe(json['warnings']),
    'manufacturer': toStringSafe(json['manufacturer']),
    'country_of_origin': toStringSafe(json['country_of_origin'] ?? json['countryOfOrigin']),
    'meta_title': toStringSafe(json['meta_title'] ?? json['metaTitle']),
    'meta_description': toStringSafe(json['meta_description'] ?? json['metaDescription']),
    'slug': toStringSafe(json['slug']),
    'sku': toStringSafe(json['sku']),
    'expiry_date': json['expiry_date'] ?? json['expiryDate'],
  };
}