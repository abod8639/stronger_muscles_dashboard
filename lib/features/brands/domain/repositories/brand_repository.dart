import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/brand_entity.dart';

/// 100% Pure Dart Abstract Repository contract for Brands.
/// Enforces functional error handling via `fpdart`'s `Either<Failure, T>`.
abstract class BrandRepository {
  /// Fetches the list of all brands.
  /// Supports [forceRefresh] to bypass local caching when needed.
  Future<Either<Failure, List<BrandEntity>>> getBrands({bool forceRefresh = false});

  /// Fetches a single brand by its unique identifier.
  Future<Either<Failure, BrandEntity>> getBrandById(String id);
}
