import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

/// Extension mapper converting [ProductModel] DTO to domain [ProductEntity].
extension ProductModelMapper on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
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
}

/// Extension mapper converting domain [ProductEntity] to [ProductModel] DTO.
extension ProductEntityMapper on ProductEntity {
  ProductModel toModel() {
    return ProductModel(
      id: id,
      name: TranslatableString(ar: nameAr, en: nameEn),
      price: price,
      discountPrice: discountPrice,
      description: TranslatableString(ar: descriptionAr, en: descriptionEn),
      imageUrls: imageUrls
          .map(
            (url) => ProductImage(thumbnail: url, medium: url, original: url),
          )
          .toList(),
      categoryId: categoryId,
      stockQuantity: stockQuantity,
      brand: brand,
      isActive: isActive,
      featured: isFeatured,
      isBackgroundWhite: isBackgroundWhite,
      servingSize: servingSize,
      servingsPerContainer: servingsPerContainer,
      productSizes: productSizes?.map((s) => s.toModel()).toList(),
      flavor: flavors,
      variants: variants?.map((v) => v.toModel()).toList() ?? const [],
    );
  }
}

/// Extension mapper converting [ProductSize] DTO to domain [ProductSizeEntity].
extension ProductSizeMapper on ProductSize {
  ProductSizeEntity toEntity() {
    return ProductSizeEntity(
      size: size,
      price: price,
      discountPrice: discountPrice,
      servings: servings,
      weight: weight,
      stockQuantity: stockQuantity,
      flavors: flavors,
    );
  }
}

/// Extension mapper converting domain [ProductSizeEntity] to [ProductSize] DTO.
extension ProductSizeEntityMapper on ProductSizeEntity {
  ProductSize toModel() {
    final model = ProductSize(
      size: size,
      price: price,
      discountPrice: discountPrice,
    );
    model.servings = servings;
    model.weight = weight;
    model.stockQuantity = stockQuantity;
    model.flavors = flavors;
    return model;
  }
}

/// Extension mapper converting [ProductVariantModel] DTO to domain [ProductVariantEntity].
extension ProductVariantModelMapper on ProductVariantModel {
  ProductVariantEntity toEntity() {
    return ProductVariantEntity(
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
}

/// Extension mapper converting domain [ProductVariantEntity] to [ProductVariantModel] DTO.
extension ProductVariantEntityMapper on ProductVariantEntity {
  ProductVariantModel toModel() {
    return ProductVariantModel(
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
}
