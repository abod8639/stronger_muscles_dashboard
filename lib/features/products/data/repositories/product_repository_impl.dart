import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      nameAr: product.nameAr,
      nameEn: product.nameEn,
      descriptionAr: product.descriptionAr,
      descriptionEn: product.descriptionEn,
      price: product.price,
      discountPrice: product.discountPrice,
      imageUrls: product.imageUrls,
      categoryId: product.categoryId,
      stockQuantity: product.stockQuantity,
      brand: product.brand,
      isActive: product.isActive,
      productSizes: product.productSizes,
      flavors: product.flavors,
    );
    return await remoteDataSource.addProduct(model);
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      nameAr: product.nameAr,
      nameEn: product.nameEn,
      descriptionAr: product.descriptionAr,
      descriptionEn: product.descriptionEn,
      price: product.price,
      discountPrice: product.discountPrice,
      imageUrls: product.imageUrls,
      categoryId: product.categoryId,
      stockQuantity: product.stockQuantity,
      brand: product.brand,
      isActive: product.isActive,
      productSizes: product.productSizes,
      flavors: product.flavors,
    );
    return await remoteDataSource.updateProduct(model);
  }

  @override
  Future<bool> deleteProduct(String id) async {
    return await remoteDataSource.deleteProduct(id);
  }
}
