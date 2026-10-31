import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

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
      _$TranslatableStringFromJson(_safeTranslatableJson(json));

  const TranslatableString._();

  String get(String lang) => lang == 'ar' ? ar : en;
  String get current => ar.isNotEmpty ? ar : en;
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
      _$ProductImageFromJson(_safeImageJson(json));
}

@freezed
@HiveType(typeId: 23)
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    @HiveField(0) required String id,
    @HiveField(1) required TranslatableString name,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(_safeCategoryJson(json));
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
      _$ProductVariantModelFromJson(_safeVariantJson(json));

  const ProductVariantModel._();
}

final Expando<Map<String, dynamic>> _sizeMetaExpando =
    Expando<Map<String, dynamic>>();

extension ProductSizeMetaExtension on ProductSize {
  int? get servings => _sizeMetaExpando[this]?['servings'] as int?;
  set servings(int? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['servings'] = value;
    _sizeMetaExpando[this] = meta;
  }

  String? get weight => _sizeMetaExpando[this]?['weight'] as String?;
  set weight(String? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['weight'] = value;
    _sizeMetaExpando[this] = meta;
  }

  int? get stockQuantity => _sizeMetaExpando[this]?['stockQuantity'] as int?;
  set stockQuantity(int? value) {
    final meta = _sizeMetaExpando[this] ?? <String, dynamic>{};
    meta['stockQuantity'] = value;
    _sizeMetaExpando[this] = meta;
  }
}

@freezed
@HiveType(typeId: 18)
class ProductSize with _$ProductSize {
  const factory ProductSize({
    @HiveField(0) required String size,
    @HiveField(1) required double price,
    @JsonKey(name: 'discount_price') @HiveField(2) double? discountPrice,
  }) = _ProductSize;

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    final size = _$ProductSizeFromJson(_safeSizeJson(json));
    final servings =
        _parseIntNullable(json['servings'] ?? json['servings_per_container']);
    final weight = (json['weight'] ?? json['serving_size'])?.toString();
    final stock = _parseIntNullable(
        json['stock_quantity'] ?? json['stockQuantity'] ?? json['stock']);
    if (servings != null ||
        (weight != null && weight.isNotEmpty) ||
        stock != null) {
      final meta = <String, dynamic>{};
      if (servings != null) meta['servings'] = servings;
      if (weight != null && weight.isNotEmpty) meta['weight'] = weight;
      if (stock != null) meta['stockQuantity'] = stock;
      _sizeMetaExpando[size] = meta;
    }
    return size;
  }

  const ProductSize._();
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
  String get displayName => name.ar.isNotEmpty ? name.ar : name.en;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(_mapProductJson(json));

  factory ProductModel.empty() => ProductModel(
    id: '',
    name: const TranslatableString(ar: 'منتج غير معروف', en: 'Unknown Product'),
    price: 0.0,
    description: const TranslatableString(ar: '', en: ''),
    imageUrls: const [],
    categoryId: '',
    stockQuantity: 0,
    variants: const [],
  );

  double get finalPrice => discountPrice ?? price;
  bool get isInStock => stockQuantity > 0;
  String get effectiveCategoryId => category?.id ?? categoryId;

  /// معالجة استخراج كائن منتج مفرد في Isolate خلفي لمنع تجميد الشاشة
  static Future<ProductModel> fromJsonAsync(dynamic json) async {
    return await compute(_parseProductIsolate, json);
  }

  /// معالجة استخراج قائمة منتجات كاملة في Isolate خلفي
  static Future<List<ProductModel>> fromJsonListAsync(dynamic data) async {
    return await compute(_parseProductListIsolate, data);
  }
}

// ==========================================
// Top-Level Isolate Functions
// ==========================================

ProductModel _parseProductIsolate(dynamic data) {
  if (data is Map) {
    try {
      return ProductModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('⚠️ Error parsing product in Isolate: $e');
    }
  }
  return ProductModel.empty();
}

List<ProductModel> _parseProductListIsolate(dynamic data) {
  final list = <ProductModel>[];
  if (data is! List) return list;
  for (final item in data) {
    if (item is Map) {
      try {
        list.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
      } catch (e) {
        debugPrint('⚠️ Error parsing product item in Isolate: $e');
      }
    }
  }
  return list;
}

// ==========================================
// Safe JSON Parsing Helpers
// ==========================================

Map<String, dynamic> _safeTranslatableJson(dynamic json) {
  if (json is Map) {
    return {
      'ar': (json['ar'] ?? json['name_ar'] ?? json['title_ar'] ?? '')
          .toString(),
      'en': (json['en'] ?? json['name_en'] ?? json['title_en'] ?? '')
          .toString(),
    };
  }
  final str = json?.toString() ?? '';
  return {'ar': str, 'en': ''};
}

Map<String, dynamic> _safeImageJson(dynamic json) {
  if (json is Map) {
    final orig = (json['original'] ?? json['url'] ?? json['image_url'] ?? '')
        .toString();
    return {
      'thumbnail': (json['thumbnail'] ?? orig).toString(),
      'medium': (json['medium'] ?? orig).toString(),
      'original': orig,
    };
  }
  final str = json?.toString() ?? '';
  return {'thumbnail': str, 'medium': str, 'original': str};
}

Map<String, dynamic> _safeCategoryJson(dynamic json) {
  if (json is Map) {
    return {
      'id': (json['id'] ?? '').toString(),
      'name': _safeTranslatableJson(json['name']),
    };
  }
  return {
    'id': '',
    'name': const {'ar': '', 'en': ''},
  };
}

Map<String, dynamic> _safeVariantJson(dynamic json) {
  if (json is! Map) {
    return {
      'id': '',
      'sku': '',
      'price': 0.0,
      'effective_price': 0.0,
      'stock_quantity': 0,
      'attributes': const <String, dynamic>{},
      'is_active': true,
    };
  }
  final map = Map<String, dynamic>.from(json);
  final price = _parseDouble(map['price']);
  final discountPrice = _parseDoubleNullable(
    map['discount_price'] ?? map['discountPrice'],
  );
  final effective = _parseDouble(
    map['effective_price'] ?? map['effectivePrice'] ?? (discountPrice ?? price),
  );

  return {
    ...map,
    'id': (map['id'] ?? '').toString(),
    'sku': (map['sku'] ?? '').toString(),
    'price': price,
    'discount_price': discountPrice,
    'effective_price': effective,
    'stock_quantity': _parseInt(map['stock_quantity'] ?? map['stockQuantity']),
    'attributes': map['attributes'] is Map
        ? Map<String, dynamic>.from(map['attributes'])
        : const <String, dynamic>{},
    'is_active': _parseBool(
      map['is_active'] ?? map['isActive'],
      defaultValue: true,
    ),
    'discount_start_date': _parseDateTime(
      map['discount_start_date'] ?? map['discountStartDate'],
    ),
    'discount_end_date': _parseDateTime(
      map['discount_end_date'] ?? map['discountEndDate'],
    ),
  };
}

Map<String, dynamic> _safeSizeJson(dynamic json) {
  if (json is! Map) {
    return {'size': '', 'price': 0.0};
  }
  final map = Map<String, dynamic>.from(json);
  return {
    ...map,
    'size': (map['size'] ?? '').toString(),
    'price': _parseDouble(map['price']),
    'discount_price': _parseDoubleNullable(
      map['discount_price'] ?? map['discountPrice'],
    ),
  };
}

Map<String, dynamic> _mapProductJson(Map<String, dynamic> rawJson) {
  Map<String, dynamic> json = Map<String, dynamic>.from(rawJson);

  // Unwrap if wrapped in Laravel response (e.g. {"status": "success", "data": {...}})
  while (json.containsKey('data') && json['data'] is Map) {
    final inner = json['data'] as Map;
    if (inner.containsKey('id') ||
        inner.containsKey('name') ||
        inner.containsKey('price')) {
      json = Map<String, dynamic>.from(inner);
    } else {
      break;
    }
  }

  String categoryId = '';
  Map<String, dynamic>? categoryObj;
  if (json['category'] is Map) {
    categoryObj = _safeCategoryJson(json['category']);
    categoryId = categoryObj['id']?.toString() ?? '';
  } else {
    categoryId = (json['category_id'] ?? json['categoryId'] ?? '').toString();
  }

  // Sanitize images
  final rawImages =
      json['imageUrls'] ?? json['image_urls'] ?? json['images'] ?? [];
  final List<Map<String, dynamic>> sanitizedImages = [];
  if (rawImages is List) {
    for (var img in rawImages) {
      sanitizedImages.add(_safeImageJson(img));
    }
  } else if (rawImages is String && rawImages.isNotEmpty) {
    sanitizedImages.add(_safeImageJson(rawImages));
  }

  // Sanitize variants
  final rawVariants = json['product_variants'] ?? json['variants'];
  final List<Map<String, dynamic>> sanitizedVariants = [];
  if (rawVariants is List) {
    for (var v in rawVariants) {
      sanitizedVariants.add(_safeVariantJson(v));
    }
  }

  // Sanitize sizes
  final rawSizes = json['product_sizes'] ?? json['sizes'];
  final List<Map<String, dynamic>> sanitizedSizes = [];
  if (rawSizes is List) {
    for (var s in rawSizes) {
      sanitizedSizes.add(_safeSizeJson(s));
    }
  }

  final price = _parseDouble(json['price']);
  final discountPrice = _parseDoubleNullable(
    json['discount_price'] ?? json['discountPrice'],
  );

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'name': _safeTranslatableJson(json['name']),
    'description': _safeTranslatableJson(json['description']),
    'price': price,
    'discount_price': discountPrice,
    'imageUrls': sanitizedImages,
    'categoryId': categoryId,
    'category': categoryObj,
    'stock_quantity': _parseInt(
      json['stock_quantity'] ?? json['stockQuantity'] ?? json['stock'],
    ),
    'average_rating': _parseDouble(
      json['average_rating'] ?? json['averageRating'],
    ),
    'review_count': _parseInt(json['review_count'] ?? json['reviewCount']),
    'brand': json['brand']?.toString(),
    'serving_size':
        json['serving_size']?.toString() ?? json['servingSize']?.toString(),
    'servings_per_container': _parseIntNullable(
      json['servings_per_container'] ?? json['servingsPerContainer'],
    ),
    'is_active': _parseBool(
      json['is_active'] ?? json['isActive'],
      defaultValue: true,
    ),
    'is_background_white': _parseBool(
      json['is_background_white'] ?? json['isBackgroundWhite'],
    ),
    'sku': json['sku']?.toString(),
    'tags': _parseStringList(json['tags']),
    'weight': _parseDoubleNullable(json['weight']),
    'size': _parseStringList(json['size']),
    'product_sizes': sanitizedSizes,
    'flavors': _parseStringList(json['flavors'] ?? json['flavor']),
    'featured': _parseBool(json['featured'] ?? json['is_featured']),
    'new_arrival': _parseBool(json['new_arrival'] ?? json['newArrival']),
    'best_seller': _parseBool(json['best_seller'] ?? json['bestSeller']),
    'total_sales': _parseInt(json['total_sales'] ?? json['totalSales']),
    'product_variants': sanitizedVariants,
    'has_variants': _parseBool(
      json['has_variants'] ?? json['hasVariants'],
      defaultValue: sanitizedVariants.isNotEmpty,
    ),
  };
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool _parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null) return defaultValue;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final s = value.toLowerCase().trim();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
  }
  return defaultValue;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final str = value.toString().trim();
  if (str.isEmpty) return null;
  return DateTime.tryParse(str);
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return const [];
  if (value is List) {
    return value
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
  if (value is String && value.isNotEmpty) {
    return [value];
  }
  return const [];
}
