import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
@HiveType(typeId: 20)
class TranslatableString with _$TranslatableString {
  const factory TranslatableString({
    @HiveField(0) @Default('') String ar,
    @HiveField(1) @Default('') String en,
  }) = _TranslatableString;

  factory TranslatableString.fromJson(Map<String, dynamic> json) =>
      _$TranslatableStringFromJson(json);

  const TranslatableString._();

  String get(String lang) => lang == 'ar' ? ar : en;
  String get current => ar; 
}

@freezed
@HiveType(typeId: 21)
class ProductImage with _$ProductImage {
  const factory ProductImage({
    @HiveField(0) required String thumbnail,
    @HiveField(1) required String medium,
    @HiveField(2) required String original,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}

@freezed
@HiveType(typeId: 23)
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    @HiveField(0) required String id,
    @HiveField(1) required TranslatableString name,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
}

@freezed
@HiveType(typeId: 22)
class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    @HiveField(0) required String id,
    @HiveField(1) required String sku,
    @HiveField(2) required double price,
    @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
    @JsonKey(name: 'effective_price')
    @HiveField(4)
    required double effectivePrice,
    @JsonKey(name: 'stock_quantity') @HiveField(5) required int stockQuantity,
    @HiveField(6) required Map<String, dynamic> attributes,
    @JsonKey(name: 'is_active') @HiveField(7) @Default(true) bool isActive,
    @JsonKey(name: 'discount_start_date')
    @HiveField(8)
    DateTime? discountStartDate,
    @JsonKey(name: 'discount_end_date') @HiveField(9) DateTime? discountEndDate,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  const ProductVariantModel._();

  ProductVariantEntity toEntity() => ProductVariantEntity(
        id: id,
        sku: sku,
        price: price,
        discountPrice: discountPrice,
        effectivePrice: effectivePrice,
        stockQuantity: stockQuantity,
        attributes: attributes,
        isActive: isActive,
      );
}

@freezed
@HiveType(typeId: 18)
class ProductSize with _$ProductSize {
  const factory ProductSize({
    @HiveField(0) required String size,
    @HiveField(1) required double price,
    @JsonKey(name: 'discount_price') @HiveField(2) double? discountPrice,
  }) = _ProductSize;

  factory ProductSize.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeFromJson(json);

  const ProductSize._();

  ProductSizeEntity toEntity() => ProductSizeEntity(
        size: size,
        price: price,
        discountPrice: discountPrice,
      );
}

@freezed
@HiveType(typeId: 8)
class ProductModel with _$ProductModel {
  const factory ProductModel({
    @HiveField(0) required String id,
    @HiveField(1) required TranslatableString name,
    @HiveField(2) required double price,
    @JsonKey(name: 'discount_price') @HiveField(3) double? discountPrice,
    @JsonKey(name: 'imageUrls')
    @HiveField(4)
    @Default([])
    List<ProductImage> imageUrls,
    @HiveField(5) required TranslatableString description,
    @HiveField(6) @Default('') String categoryId,
    @HiveField(27) ProductCategory? category,
    @JsonKey(name: 'stock_quantity')
    @HiveField(7)
    @Default(0)
    int stockQuantity,
    @JsonKey(name: 'average_rating')
    @HiveField(8)
    @Default(0.0)
    double averageRating,
    @JsonKey(name: 'review_count') @HiveField(9) @Default(0) int reviewCount,
    @HiveField(10) String? brand,
    @JsonKey(name: 'serving_size') @HiveField(11) String? servingSize,
    @JsonKey(name: 'servings_per_container')
    @HiveField(12)
    int? servingsPerContainer,
    @JsonKey(name: 'is_active') @HiveField(13) @Default(true) bool isActive,
    @JsonKey(name: 'is_background_white')
    @HiveField(14)
    @Default(false)
    bool? isBackgroundWhite,
    @HiveField(15) String? sku,
    @HiveField(16) @Default([]) List<String>? tags,
    @HiveField(17) double? weight,
    @HiveField(18) @Default([]) List<String>? size,
    @JsonKey(name: 'product_sizes')
    @HiveField(19)
    @Default([])
    List<ProductSize>? productSizes,
    @JsonKey(name: 'flavors') @HiveField(20) @Default([]) List<String>? flavor,
    @JsonKey(name: 'nutrition_facts')
    @HiveField(21)
    Map<String, dynamic>? nutritionFacts,
    @HiveField(22) @Default(false) bool featured,
    @JsonKey(name: 'new_arrival')
    @HiveField(23)
    @Default(false)
    bool newArrival,
    @JsonKey(name: 'best_seller')
    @HiveField(24)
    @Default(false)
    bool bestSeller,
    @JsonKey(name: 'total_sales') @HiveField(25) @Default(0) int totalSales,
    @JsonKey(name: 'product_variants')
    @HiveField(26)
    @Default([])
    List<ProductVariantModel> variants,
    @JsonKey(name: 'has_variants')
    @HiveField(28)
    @Default(false)
    bool hasVariants,
  }) = _ProductModel;

  const ProductModel._();
  String get displayName => name.ar;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(_mapProductJson(json));

  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;
  String get effectiveCategoryId => category?.id ?? categoryId;

  ProductEntity toEntity() => ProductEntity(
        id: id,
        nameAr: name.ar,
        nameEn: name.en,
        descriptionAr: description.ar,
        descriptionEn: description.en,
        price: price,
        discountPrice: discountPrice,
        imageUrls: imageUrls.map((e) => e.original).toList(),
        categoryId: effectiveCategoryId,
        stockQuantity: stockQuantity,
        brand: brand,
        isActive: isActive,
        isFeatured: featured,
        isBackgroundWhite: isBackgroundWhite,
        servingSize: servingSize,
        servingsPerContainer: servingsPerContainer,
        productSizes: productSizes?.map((e) => e.toEntity()).toList(),
        flavors: flavor,
        variants: variants.map((e) => e.toEntity()).toList(),
      );
}

Map<String, dynamic> _mapProductJson(Map<String, dynamic> json) {
  dynamic parseTranslatable(dynamic val) {
    if (val is Map) return val;
    return {'ar': val?.toString() ?? '', 'en': ''};
  }

  String categoryId = '';
  Map<String, dynamic>? categoryObj;
  if (json['category'] is Map) {
    categoryObj = Map<String, dynamic>.from(json['category'] as Map);
    categoryId = categoryObj['id']?.toString() ?? '';
    if (categoryObj['name'] is! Map) {
      categoryObj['name'] = {
        'ar': categoryObj['name']?.toString() ?? '',
        'en': '',
      };
    }
  } else {
    categoryId = (json['category_id'] ?? json['categoryId'] ?? '').toString();
  }

  final variantsRaw = json['product_variants'] ?? json['variants'] ?? [];

  return {
    ...json,
    'name': parseTranslatable(json['name']),
    'description': parseTranslatable(json['description']),
    'imageUrls': (json['imageUrls'] ?? json['image_urls'] ?? [])
        .map((e) => e is Map ? e : {'thumbnail': e, 'medium': e, 'original': e})
        .toList(),
    'categoryId': categoryId,
    'category': categoryObj,
    'product_variants': variantsRaw,
    'has_variants': json['has_variants'] ?? (variantsRaw as List).isNotEmpty,
  };
}
