import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 8) // تأكد من أن هذا الـ ID فريد في مشروعك
class ProductModel with _$ProductModel {
  const ProductModel._();

  @JsonSerializable(explicitToJson: true)
  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required double price,
    @HiveField(3) @JsonKey(name: 'discount_price') double? discountPrice,
    @HiveField(4) @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    @HiveField(5) required String description,
    @HiveField(6) @JsonKey(name: 'category_id') required String categoryId,
    @HiveField(7) @JsonKey(name: 'stock_quantity') @Default(0) int stockQuantity,
    @HiveField(8) @JsonKey(name: 'average_rating') @Default(0.0) double averageRating,
    @HiveField(9) @JsonKey(name: 'review_count') @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @HiveField(11) @JsonKey(name: 'serving_size') String? servingSize,
    @HiveField(12) @JsonKey(name: 'servings_per_container') int? servingsPerContainer,
    @HiveField(13) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @HiveField(14) @JsonKey(name: 'is_background_white') @Default(false) bool? isBackgroundWhite,

    @HiveField(15) String? sku,
    @HiveField(16) @Default([]) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) @Default([]) List<String>? size,
    @HiveField(19) @JsonKey(name: 'flavors') @Default([]) List<String>? flavor,
    @HiveField(20) @JsonKey(name: 'nutrition_facts') Map<String, dynamic>? nutritionFacts,

    @HiveField(21) @Default(false) bool featured,
    @HiveField(22) @JsonKey(name: 'new_arrival') @Default(false) bool newArrival,
    @HiveField(23) @JsonKey(name: 'best_seller') @Default(false) bool bestSeller,
    @HiveField(24) @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @HiveField(25) @JsonKey(name: 'views_count') @Default(0) int viewsCount,

    @HiveField(26) @JsonKey(name: 'shipping_weight') double? shippingWeight,
    @HiveField(27) Map<String, dynamic>? dimensions,

    @HiveField(28) @Default([]) List<String> ingredients,
    @HiveField(29) @JsonKey(name: 'usage_instructions') String? usageInstructions,
    @HiveField(30) String? warnings,
    @HiveField(31) @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    @HiveField(32) String? manufacturer,
    @HiveField(33) @JsonKey(name: 'country_of_origin') String? countryOfOrigin,

    @HiveField(34) @JsonKey(name: 'meta_title') String? metaTitle,
    @HiveField(35) @JsonKey(name: 'meta_description') String? metaDescription,
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
    'image_urls': toList(json['image_urls'] ?? json['imageUrls']),
    'flavors': toList(json['flavors'] ?? json['flavor']),
    'price': double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    'discount_price': (json['discount_price'] != null || json['discountPrice'] != null)
        ? double.tryParse((json['discount_price'] ?? json['discountPrice']).toString())
        : null,
    'stock_quantity': int.tryParse((json['stock_quantity'] ?? json['stockQuantity'] ?? 0).toString()) ?? 0,
    'is_active': json['is_active'] == true || json['is_active'] == 1 || json['isActive'] == true,
    'expiry_date': json['expiry_date'] ?? json['expiryDate'],
  };
}