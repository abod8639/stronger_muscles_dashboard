import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_local_datasource.dart';
import '../datasources/brand_remote_datasource.dart';
import '../mappers/brand_mapper.dart';

/// Single Source of Truth for Brands data.
/// Orchestrates calls between [BrandRemoteDataSource] (Dio) and [BrandLocalDataSource] (Hive).
/// Converts raw data to domain entities via extension mappers and handles exceptions functionally.
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource _remoteDataSource;
  final BrandLocalDataSource _localDataSource;

  const BrandRepositoryImpl({
    required BrandRemoteDataSource remoteDataSource,
    required BrandLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands({
    bool forceRefresh = false,
  }) async {
    // 1. Check local Hive cache first if not forcing a refresh
    if (!forceRefresh) {
      try {
        final isCacheValid = await _localDataSource.isCacheValid();
        if (isCacheValid) {
          final cachedModels = await _localDataSource.getCachedBrands();
          if (cachedModels.isNotEmpty) {
            return Right(cachedModels.toEntities());
          }
        }
      } catch (_) {
        // Cache read issue: proceed to network fetch
      }
    }

    // 2. Fetch fresh data from remote API
    try {
      final remoteModels = await _remoteDataSource.getBrands();

      // Update local cache asynchronously
      await _localDataSource.cacheBrands(remoteModels);

      return Right(remoteModels.toEntities());
    } catch (e, stackTrace) {
      // 3. Network fallback: If network fails, serve stale local cache if available
      try {
        final cachedModels = await _localDataSource.getCachedBrands();
        if (cachedModels.isNotEmpty) {
          return Right(cachedModels.toEntities());
        }
      } catch (_) {
        // Ignore fallback failure and return original network error
      }

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, BrandEntity>> getBrandById(String id) async {
    try {
      // 1. Check if present in cached brands
      try {
        final cached = await _localDataSource.getCachedBrands();
        final found = cached.where((b) => b.id == id);
        if (found.isNotEmpty) {
          return Right(found.first.toEntity());
        }
      } catch (_) {}

      // 2. Fetch directly from remote
      final model = await _remoteDataSource.getBrandById(id);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
