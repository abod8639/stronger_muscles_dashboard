import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call({
    bool tree = true,
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    return await repository.getCategories(
      tree: tree,
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );
  }
}
