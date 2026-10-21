import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
    String id, {
    CancelToken? cancelToken,
  }) async {
    return await repository.deleteCategory(id, cancelToken: cancelToken);
  }
}
