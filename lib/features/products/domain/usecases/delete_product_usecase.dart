import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, bool>> call(
    String id, {
    CancelToken? cancelToken,
  }) async {
    return await repository.deleteProduct(id, cancelToken: cancelToken);
  }
}