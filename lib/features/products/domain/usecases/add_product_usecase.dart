import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  }) async {
    return await repository.addProduct(productData, cancelToken: cancelToken);
  }
}
