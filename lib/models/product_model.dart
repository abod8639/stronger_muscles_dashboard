import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String name,
    required double price,
    @JsonKey(name: 'discount_price') double? discountPrice,
    // لاحظ استخدام اسم المفتاح الموحد الذي ننتجه في الدالة بالأسفل
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    required String description,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @JsonKey(name: 'average_rating') @Default(0.0) double averageRating,
    @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    String? brand,
    @JsonKey(name: 'serving_size') String? servingSize,
    @JsonKey(name: 'servings_per_container') int? servingsPerContainer,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_background_white') @Default(false) bool? isBackgroundWhite,

    String? sku,
    @Default([]) List<String>? tags,
    double? weight,
    @Default([]) List<String>? size,
    @JsonKey(name: 'flavors') @Default([]) List<String>? flavor,
    @JsonKey(name: 'nutrition_facts') Map<String, dynamic>? nutritionFacts,

    @Default(false) bool featured,
    @JsonKey(name: 'new_arrival') @Default(false) bool newArrival,
    @JsonKey(name: 'best_seller') @Default(false) bool bestSeller,
    @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @JsonKey(name: 'views_count') @Default(0) int viewsCount,

    @JsonKey(name: 'shipping_weight') double? shippingWeight,
    Map<String, dynamic>? dimensions,

    @Default([]) List<String> ingredients,
    @JsonKey(name: 'usage_instructions') String? usageInstructions,
    String? warnings,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? manufacturer,
    @JsonKey(name: 'country_of_origin') String? countryOfOrigin,

    @JsonKey(name: 'meta_title') String? metaTitle,
    @JsonKey(name: 'meta_description') String? metaDescription,
    String? slug,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => 
      _$ProductModelFromJson(_mapProductJson(json));

  // Getters (كما هي في كودك)
  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;
}

Map<String, dynamic> _mapProductJson(Map<String, dynamic> json) {
  List<String> toList(dynamic val) {
    if (val == null) return [];
    if (val is List) return val.map((e) => e.toString()).toList();
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
    'discount_price': json['discount_price'] != null || json['discountPrice'] != null 
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
  };
}