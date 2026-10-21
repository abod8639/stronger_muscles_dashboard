import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(
    String id,
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  }) async {
    return await repository.updateProduct(
      id,
      productData,
      cancelToken: cancelToken,
    );
  }
}
