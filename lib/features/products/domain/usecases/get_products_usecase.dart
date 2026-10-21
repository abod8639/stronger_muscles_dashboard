import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    return await repository.getProducts(
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );
  }
}
