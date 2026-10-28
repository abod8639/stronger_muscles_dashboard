import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/promo_entity.dart';

/// Pure Dart abstract repository contract for promotional banners.
/// Adheres strictly to Clean Architecture: zero dependencies on Flutter UI, Dio, or Hive.
abstract class PromoRepository {
  /// Fetches all promotional banners.
  Future<Either<Failure, List<PromoEntity>>> getPromos();

  /// Adds a new promotional banner.
  Future<Either<Failure, PromoEntity>> addPromo(PromoEntity promo);

  /// Updates an existing promotional banner.
  Future<Either<Failure, PromoEntity>> updatePromo(PromoEntity promo);

  /// Deletes a promotional banner by ID.
  Future<Either<Failure, Unit>> deletePromo(String id);

  /// Uploads a promotional banner image and returns the public URL.
  Future<Either<Failure, String>> uploadImage(String filePath);
}
