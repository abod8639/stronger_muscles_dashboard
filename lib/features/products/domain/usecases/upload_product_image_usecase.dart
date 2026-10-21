import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/product_repository.dart';

class UploadProductImageUseCase {
  final ProductRepository repository;

  UploadProductImageUseCase(this.repository);

  Future<Either<Failure, String>> call(
    String filePath, {
    CancelToken? cancelToken,
  }) async {
    return await repository.uploadImage(filePath, cancelToken: cancelToken);
  }
}
