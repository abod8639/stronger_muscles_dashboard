// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslatableStringAdapter extends TypeAdapter<TranslatableString> {
  @override
  final int typeId = 20;

  @override
  TranslatableString read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslatableString(
      ar: fields[0] as String,
      en: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TranslatableString obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ar)
      ..writeByte(1)
      ..write(obj.en);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslatableStringAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductImageAdapter extends TypeAdapter<ProductImage> {
  @override
  final int typeId = 21;

  @override
  ProductImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductImage(
      thumbnail: fields[0] as String,
      medium: fields[1] as String,
      original: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.thumbnail)
      ..writeByte(1)
      ..write(obj.medium)
      ..writeByte(2)
      ..write(obj.original);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductCategoryAdapter extends TypeAdapter<ProductCategory> {
  @override
  final int typeId = 23;

  @override
  ProductCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCategory(
      id: fields[0] as String,
      name: fields[1] as TranslatableString,
    );
  }

  @override
  void write(BinaryWriter writer, ProductCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductVariantModelAdapter extends TypeAdapter<ProductVariantModel> {
  @override
  final int typeId = 22;

  @override
  ProductVariantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductVariantModel(
      id: fields[0] as String,
      sku: fields[1] as String,
      price: fields[2] as double,
      discountPrice: fields[3] as double?,
      effectivePrice: fields[4] as double,
      stockQuantity: fields[5] as int,
      attributes: (fields[6] as Map).cast<String, dynamic>(),
      isActive: fields[7] as bool,
      discountStartDate: fields[8] as DateTime?,
      discountEndDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductVariantModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sku)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.discountPrice)
      ..writeByte(4)
      ..write(obj.effectivePrice)
      ..writeByte(5)
      ..write(obj.stockQuantity)
      ..writeByte(6)
      ..write(obj.attributes)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.discountStartDate)
      ..writeByte(9)
      ..write(obj.discountEndDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductSizeAdapter extends TypeAdapter<ProductSize> {
  @override
  final int typeId = 18;

  @override
  ProductSize read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSize(
      size: fields[0] as String,
      price: fields[1] as double,
      discountPrice: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductSize obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.size)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.discountPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      name: fields[1] as TranslatableString,
      price: fields[2] as double,
      discountPrice: fields[3] as double?,
      imageUrls: (fields[4] as List).cast<ProductImage>(),
      description: fields[5] as TranslatableString,
      categoryId: fields[6] as String,
      category: fields[27] as ProductCategory?,
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
      productSizes: (fields[19] as List?)?.cast<ProductSize>(),
      flavor: (fields[20] as List?)?.cast<String>(),
      nutritionFacts: (fields[21] as Map?)?.cast<String, dynamic>(),
      featured: fields[22] as bool,
      newArrival: fields[23] as bool,
      bestSeller: fields[24] as bool,
      totalSales: fields[25] as int,
      variants: (fields[26] as List).cast<ProductVariantModel>(),
      hasVariants: fields[28] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(29)
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
      ..writeByte(27)
      ..write(obj.category)
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
      ..write(obj.productSizes)
      ..writeByte(20)
      ..write(obj.flavor)
      ..writeByte(21)
      ..write(obj.nutritionFacts)
      ..writeByte(22)
      ..write(obj.featured)
      ..writeByte(23)
      ..write(obj.newArrival)
      ..writeByte(24)
      ..write(obj.bestSeller)
      ..writeByte(25)
      ..write(obj.totalSales)
      ..writeByte(26)
      ..write(obj.variants)
      ..writeByte(28)
      ..write(obj.hasVariants);
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

_$TranslatableStringImpl _$$TranslatableStringImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslatableStringImpl(
      ar: json['ar'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );

Map<String, dynamic> _$$TranslatableStringImplToJson(
        _$TranslatableStringImpl instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'en': instance.en,
    };

_$ProductImageImpl _$$ProductImageImplFromJson(Map<String, dynamic> json) =>
    _$ProductImageImpl(
      thumbnail: json['thumbnail'] as String,
      medium: json['medium'] as String,
      original: json['original'] as String,
    );

Map<String, dynamic> _$$ProductImageImplToJson(_$ProductImageImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'original': instance.original,
    };

_$ProductCategoryImpl _$$ProductCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductCategoryImpl(
      id: json['id'] as String,
      name: TranslatableString.fromJson(json['name'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProductCategoryImplToJson(
        _$ProductCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_$ProductVariantModelImpl _$$ProductVariantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductVariantModelImpl(
      id: json['id'] as String,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      effectivePrice: (json['effective_price'] as num).toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      attributes: json['attributes'] as Map<String, dynamic>,
      isActive: json['is_active'] as bool? ?? true,
      discountStartDate: json['discount_start_date'] == null
          ? null
          : DateTime.parse(json['discount_start_date'] as String),
      discountEndDate: json['discount_end_date'] == null
          ? null
          : DateTime.parse(json['discount_end_date'] as String),
    );

Map<String, dynamic> _$$ProductVariantModelImplToJson(
        _$ProductVariantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'effective_price': instance.effectivePrice,
      'stock_quantity': instance.stockQuantity,
      'attributes': instance.attributes,
      'is_active': instance.isActive,
      'discount_start_date': instance.discountStartDate?.toIso8601String(),
      'discount_end_date': instance.discountEndDate?.toIso8601String(),
    };

_$ProductSizeImpl _$$ProductSizeImplFromJson(Map<String, dynamic> json) =>
    _$ProductSizeImpl(
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ProductSizeImplToJson(_$ProductSizeImpl instance) =>
    <String, dynamic>{
      'size': instance.size,
      'price': instance.price,
      'discount_price': instance.discountPrice,
    };

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String,
      name: TranslatableString.fromJson(json['name'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      description: TranslatableString.fromJson(
          json['description'] as Map<String, dynamic>),
      categoryId: json['categoryId'] as String? ?? '',
      category: json['category'] == null
          ? null
          : ProductCategory.fromJson(json['category'] as Map<String, dynamic>),
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
      productSizes: (json['product_sizes'] as List<dynamic>?)
              ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
              .toList() ??
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
      variants: (json['product_variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasVariants: json['has_variants'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'discount_price': instance.discountPrice,
      'imageUrls': instance.imageUrls,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'category': instance.category,
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
      'product_sizes': instance.productSizes,
      'flavors': instance.flavor,
      'nutrition_facts': instance.nutritionFacts,
      'featured': instance.featured,
      'new_arrival': instance.newArrival,
      'best_seller': instance.bestSeller,
      'total_sales': instance.totalSales,
      'product_variants': instance.variants,
      'has_variants': instance.hasVariants,
    };
