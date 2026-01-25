// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 8;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      discountPrice: fields[3] as double?,
      imageUrls: (fields[4] as List).cast<String>(),
      description: fields[5] as String,
      categoryId: fields[6] as String,
      stockQuantity: fields[7] as int,
      averageRating: fields[8] as double,
      reviewCount: fields[9] as int,
      brand: fields[10] as String?,
      servingSize: fields[11] as String?,
      servingsPerContainer: fields[12] as int?,
      isActive: fields[13] as bool,
      isBackgroundWhite: fields[14] as bool?,
      sku: fields[15] as String?,
      tags: (fields[16] as List?)?.cast<String>(),
      weight: fields[17] as double?,
      size: (fields[18] as List?)?.cast<String>(),
      flavor: (fields[19] as List?)?.cast<String>(),
      nutritionFacts: (fields[20] as Map?)?.cast<String, dynamic>(),
      featured: fields[21] as bool,
      newArrival: fields[22] as bool,
      bestSeller: fields[23] as bool,
      totalSales: fields[24] as int,
      viewsCount: fields[25] as int,
      shippingWeight: fields[26] as double?,
      dimensions: (fields[27] as Map?)?.cast<String, dynamic>(),
      ingredients: (fields[28] as List).cast<String>(),
      usageInstructions: fields[29] as String?,
      warnings: fields[30] as String?,
      expiryDate: fields[31] as DateTime?,
      manufacturer: fields[32] as String?,
      countryOfOrigin: fields[33] as String?,
      metaTitle: fields[34] as String?,
      metaDescription: fields[35] as String?,
      slug: fields[36] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(37)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.discountPrice)
      ..writeByte(4)
      ..write(obj.imageUrls)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.stockQuantity)
      ..writeByte(8)
      ..write(obj.averageRating)
      ..writeByte(9)
      ..write(obj.reviewCount)
      ..writeByte(10)
      ..write(obj.brand)
      ..writeByte(11)
      ..write(obj.servingSize)
      ..writeByte(12)
      ..write(obj.servingsPerContainer)
      ..writeByte(13)
      ..write(obj.isActive)
      ..writeByte(14)
      ..write(obj.isBackgroundWhite)
      ..writeByte(15)
      ..write(obj.sku)
      ..writeByte(16)
      ..write(obj.tags)
      ..writeByte(17)
      ..write(obj.weight)
      ..writeByte(18)
      ..write(obj.size)
      ..writeByte(19)
      ..write(obj.flavor)
      ..writeByte(20)
      ..write(obj.nutritionFacts)
      ..writeByte(21)
      ..write(obj.featured)
      ..writeByte(22)
      ..write(obj.newArrival)
      ..writeByte(23)
      ..write(obj.bestSeller)
      ..writeByte(24)
      ..write(obj.totalSales)
      ..writeByte(25)
      ..write(obj.viewsCount)
      ..writeByte(26)
      ..write(obj.shippingWeight)
      ..writeByte(27)
      ..write(obj.dimensions)
      ..writeByte(28)
      ..write(obj.ingredients)
      ..writeByte(29)
      ..write(obj.usageInstructions)
      ..writeByte(30)
      ..write(obj.warnings)
      ..writeByte(31)
      ..write(obj.expiryDate)
      ..writeByte(32)
      ..write(obj.manufacturer)
      ..writeByte(33)
      ..write(obj.countryOfOrigin)
      ..writeByte(34)
      ..write(obj.metaTitle)
      ..writeByte(35)
      ..write(obj.metaDescription)
      ..writeByte(36)
      ..write(obj.slug);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
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
      flavor:
          (json['flavors'] as List<dynamic>?)
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
      ingredients:
          (json['ingredients'] as List<dynamic>?)
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
