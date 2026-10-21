import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, ProductEntity>> getProductById(
    String id, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, ProductEntity>> addProduct(
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, bool>> deleteProduct(
    String id, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, String>> uploadImage(
    String filePath, {
    CancelToken? cancelToken,
  });
}
