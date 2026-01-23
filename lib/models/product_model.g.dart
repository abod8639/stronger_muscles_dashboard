// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String,
      categoryId: json['category_id'] as String,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt() ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      servingSize: json['serving_size'] as String?,
      servingsPerContainer: (json['servings_per_container'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      isBackgroundWhite: json['is_background_white'] as bool? ?? false,
      sku: json['sku'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      weight: (json['weight'] as num?)?.toDouble(),
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      flavor: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionFacts: json['nutrition_facts'] as Map<String, dynamic>?,
      featured: json['featured'] as bool? ?? false,
      newArrival: json['new_arrival'] as bool? ?? false,
      bestSeller: json['best_seller'] as bool? ?? false,
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      shippingWeight: (json['shipping_weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as Map<String, dynamic>?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usageInstructions: json['usage_instructions'] as String?,
      warnings: json['warnings'] as String?,
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      metaTitle: json['meta_title'] as String?,
      metaDescription: json['meta_description'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'image_urls': instance.imageUrls,
      'description': instance.description,
      'category_id': instance.categoryId,
      'stock_quantity': instance.stockQuantity,
      'average_rating': instance.averageRating,
      'review_count': instance.reviewCount,
      'brand': instance.brand,
      'serving_size': instance.servingSize,
      'servings_per_container': instance.servingsPerContainer,
      'is_active': instance.isActive,
      'is_background_white': instance.isBackgroundWhite,
      'sku': instance.sku,
      'tags': instance.tags,
      'weight': instance.weight,
      'size': instance.size,
      'flavors': instance.flavor,
      'nutrition_facts': instance.nutritionFacts,
      'featured': instance.featured,
      'new_arrival': instance.newArrival,
      'best_seller': instance.bestSeller,
      'total_sales': instance.totalSales,
      'views_count': instance.viewsCount,
      'shipping_weight': instance.shippingWeight,
      'dimensions': instance.dimensions,
      'ingredients': instance.ingredients,
      'usage_instructions': instance.usageInstructions,
      'warnings': instance.warnings,
      'expiry_date': instance.expiryDate?.toIso8601String(),
      'manufacturer': instance.manufacturer,
      'country_of_origin': instance.countryOfOrigin,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'slug': instance.slug,
    };
