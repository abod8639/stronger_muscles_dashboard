import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, CategoryEntity>> addCategory(
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, CategoryEntity>> updateCategory(
    String id,
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> deleteCategory(
    String id, {
    CancelToken? cancelToken,
  });
}
