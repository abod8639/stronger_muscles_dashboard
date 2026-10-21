import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  Future<Either<Failure, CategoryEntity>> call(
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    return await repository.addCategory(categoryData, cancelToken: cancelToken);
  }
}
