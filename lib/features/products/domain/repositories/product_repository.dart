import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';

/// 100% Pure Dart Abstract Repository Contract.
/// Zero imports from Flutter UI, Dio, Hive, or 3rd-party networking SDKs.
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    bool forceRefresh = false,
  });

  Future<Either<Failure, ProductEntity>> getProductById(String id);

  Future<Either<Failure, ProductEntity>> addProduct(
    Map<String, dynamic> productData,
  );

  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> productData,
  );

  Future<Either<Failure, bool>> deleteProduct(String id);

  Future<Either<Failure, String>> uploadImage(String filePath);
}
