import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryEntity>> call(
    String id,
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    return await repository.updateCategory(
      id,
      categoryData,
      cancelToken: cancelToken,
    );
  }
}
