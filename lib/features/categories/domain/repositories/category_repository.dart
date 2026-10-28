import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';

/// Pure Dart Repository Contract for the Categories feature.
/// Strictly decoupled from Flutter, Dio, Hive, and 3rd-party networking libraries.
abstract class CategoryRepository {
  /// Fetches categories list. If [tree] is true, returns hierarchical tree.
  /// If [forceRefresh] is true, bypasses the local cache.
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  });

  /// Fetches a single category by its unique identifier.
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);

  /// Creates a new category using a strongly-typed [CategoryEntity].
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category);

  /// Updates an existing category using a strongly-typed [CategoryEntity].
  Future<Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category);

  /// Deletes a category by its unique identifier.
  Future<Either<Failure, Unit>> deleteCategory(String id);
}
