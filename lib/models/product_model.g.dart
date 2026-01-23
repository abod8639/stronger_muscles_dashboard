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
      isBackgroundWhite: fields[14] as bool,
      sku: fields[15] as String?,
      tags: (fields[16] as List?)?.cast<String>(),
      weight: fields[17] as double?,
      size: (fields[18] as List).cast<String>(),
      flavor: (fields[19] as List).cast<String>(),
      nutritionFacts: (fields[20] as Map?)?.cast<String, dynamic>(),
      dimensions: (fields[21] as Map?)?.cast<String, dynamic>(),
      featured: fields[22] as bool,
      newArrival: fields[23] as bool,
      bestSeller: fields[24] as bool,
      totalSales: fields[25] as int,
      viewsCount: fields[26] as int,
      ingredients: fields[27] as String?,
      usageInstructions: fields[28] as String?,
      warnings: fields[29] as String?,
      expiryDate: fields[30] as DateTime?,
      manufacturer: fields[31] as String?,
      countryOfOrigin: fields[32] as String?,
      metaTitle: fields[33] as String?,
      metaDescription: fields[34] as String?,
      slug: fields[35] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(36)
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
      ..write(obj.dimensions)
      ..writeByte(22)
      ..write(obj.featured)
      ..writeByte(23)
      ..write(obj.newArrival)
      ..writeByte(24)
      ..write(obj.bestSeller)
      ..writeByte(25)
      ..write(obj.totalSales)
      ..writeByte(26)
      ..write(obj.viewsCount)
      ..writeByte(27)
      ..write(obj.ingredients)
      ..writeByte(28)
      ..write(obj.usageInstructions)
      ..writeByte(29)
      ..write(obj.warnings)
      ..writeByte(30)
      ..write(obj.expiryDate)
      ..writeByte(31)
      ..write(obj.manufacturer)
      ..writeByte(32)
      ..write(obj.countryOfOrigin)
      ..writeByte(33)
      ..write(obj.metaTitle)
      ..writeByte(34)
      ..write(obj.metaDescription)
      ..writeByte(35)
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

// ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       price: (json['price'] as num).toDouble(),
//       discountPrice: (json['discountPrice'] as num?)?.toDouble(),
//       imageUrls:
//           (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
//       description: json['description'] as String,
//       categoryId: json['categoryId'] as String,
//       stockQuantity: (json['stockQuantity'] as num).toInt(),
//       averageRating: (json['averageRating'] as num).toDouble(),
//       reviewCount: (json['reviewCount'] as num).toInt(),
//       brand: json['brand'] as String?,
//       servingSize: json['servingSize'] as String?,
//       servingsPerContainer: (json['servingsPerContainer'] as num?)?.toInt(),
//       isActive: json['isActive'] as bool,
//       isBackgroundWhite: json['isBackgroundWhite'] as bool,
//       sku: json['sku'] as String?,
//       tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
//       weight: (json['weight'] as num?)?.toDouble(),
//       size: (json['size'] as List<dynamic>).map((e) => e as String).toList(),
//       flavor:
//           (json['flavors'] as List<dynamic>).map((e) => e as String).toList(),
//       nutritionFacts: json['nutritionFacts'] as Map<String, dynamic>?,
//       dimensions: json['dimensions'] as Map<String, dynamic>?,
//       featured: json['featured'] as bool,
//       newArrival: json['newArrival'] as bool,
//       bestSeller: json['bestSeller'] as bool,
//       totalSales: (json['totalSales'] as num).toInt(),
//       viewsCount: (json['viewsCount'] as num).toInt(),
//       ingredients: json['ingredients'] as String?,
//       usageInstructions: json['usageInstructions'] as String?,
//       warnings: json['warnings'] as String?,
//       expiryDate: json['expiryDate'] == null
//           ? null
//           : DateTime.parse(json['expiryDate'] as String),
//       manufacturer: json['manufacturer'] as String?,
//       countryOfOrigin: json['countryOfOrigin'] as String?,
//       metaTitle: json['metaTitle'] as String?,
//       metaDescription: json['metaDescription'] as String?,
//       slug: json['slug'] as String?,
//     );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'imageUrls': instance.imageUrls,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'stockQuantity': instance.stockQuantity,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'brand': instance.brand,
      'servingSize': instance.servingSize,
      'servingsPerContainer': instance.servingsPerContainer,
      'isActive': instance.isActive,
      'isBackgroundWhite': instance.isBackgroundWhite,
      'sku': instance.sku,
      'tags': instance.tags,
      'weight': instance.weight,
      'size': instance.size,
      'flavors': instance.flavor,
      'nutritionFacts': instance.nutritionFacts,
      'dimensions': instance.dimensions,
      'featured': instance.featured,
      'newArrival': instance.newArrival,
      'bestSeller': instance.bestSeller,
      'totalSales': instance.totalSales,
      'viewsCount': instance.viewsCount,
      'ingredients': instance.ingredients,
      'usageInstructions': instance.usageInstructions,
      'warnings': instance.warnings,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'manufacturer': instance.manufacturer,
      'countryOfOrigin': instance.countryOfOrigin,
      'metaTitle': instance.metaTitle,
      'metaDescription': instance.metaDescription,
      'slug': instance.slug,
    };

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      servingSize: json['servingSize'] as String?,
      servingsPerContainer: (json['servingsPerContainer'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      isBackgroundWhite: json['isBackgroundWhite'] as bool? ?? false,
      sku: json['sku'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      weight: (json['weight'] as num?)?.toDouble(),
      size:
          (json['size'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      flavor: (json['flavors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionFacts: json['nutritionFacts'] as Map<String, dynamic>?,
      dimensions: json['dimensions'] as Map<String, dynamic>?,
      featured: json['featured'] as bool? ?? false,
      newArrival: json['newArrival'] as bool? ?? false,
      bestSeller: json['bestSeller'] as bool? ?? false,
      totalSales: (json['totalSales'] as num?)?.toInt() ?? 0,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      ingredients: json['ingredients'] as String?,
      usageInstructions: json['usageInstructions'] as String?,
      warnings: json['warnings'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['countryOfOrigin'] as String?,
      metaTitle: json['metaTitle'] as String?,
      metaDescription: json['metaDescription'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'imageUrls': instance.imageUrls,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'stockQuantity': instance.stockQuantity,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
      'brand': instance.brand,
      'servingSize': instance.servingSize,
      'servingsPerContainer': instance.servingsPerContainer,
      'isActive': instance.isActive,
      'isBackgroundWhite': instance.isBackgroundWhite,
      'sku': instance.sku,
      'tags': instance.tags,
      'weight': instance.weight,
      'size': instance.size,
      'flavors': instance.flavor,
      'nutritionFacts': instance.nutritionFacts,
      'dimensions': instance.dimensions,
      'featured': instance.featured,
      'newArrival': instance.newArrival,
      'bestSeller': instance.bestSeller,
      'totalSales': instance.totalSales,
      'viewsCount': instance.viewsCount,
      'ingredients': instance.ingredients,
      'usageInstructions': instance.usageInstructions,
      'warnings': instance.warnings,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'manufacturer': instance.manufacturer,
      'countryOfOrigin': instance.countryOfOrigin,
      'metaTitle': instance.metaTitle,
      'metaDescription': instance.metaDescription,
      'slug': instance.slug,
    };
