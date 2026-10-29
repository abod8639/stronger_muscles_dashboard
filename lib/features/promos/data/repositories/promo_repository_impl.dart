import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/repositories/promo_repository.dart';
import '../datasources/promo_local_datasource.dart';
import '../datasources/promo_remote_datasource.dart';
import '../mappers/promo_mapper.dart';

/// Single Source of Truth (SSOT) implementation of [PromoRepository].
/// Coordinates between [PromoRemoteDataSource] (Dio) and [PromoLocalDataSource] (Hive)
/// with offline caching resilience and functional error handling via [Either].
class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteDataSource;
  final PromoLocalDataSource _localDataSource;

  const PromoRepositoryImpl({
    required PromoRemoteDataSource remoteDataSource,
    required PromoLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromos() async {
    try {
      final remoteModels = await _remoteDataSource.getPromos();
      await _localDataSource.cachePromos(remoteModels);
      final entities = remoteModels.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, stackTrace) {
      debugPrint(
        '⚠️ [PromoRepositoryImpl] Remote fetch failed, checking local cache: $e',
      );
      try {
        final cachedModels = await _localDataSource.getCachedPromos();
        if (cachedModels.isNotEmpty) {
          debugPrint(
            '✅ [PromoRepositoryImpl] Serving ${cachedModels.length} promos from Hive cache',
          );
          return Right(cachedModels.map((m) => m.toEntity()).toList());
        }
      } catch (cacheError) {
        debugPrint(
          '⚠️ [PromoRepositoryImpl] Hive cache read error: $cacheError',
        );
      }
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, PromoEntity>> addPromo(PromoEntity promo) async {
    try {
      final model = promo.toModel();
      final addedModel = await _remoteDataSource.addPromo(model.toJson());
      await _localDataSource.cachePromo(addedModel);
      return Right(addedModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ [PromoRepositoryImpl.addPromo] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, PromoEntity>> updatePromo(PromoEntity promo) async {
    try {
      final model = promo.toModel();
      final updatedModel = await _remoteDataSource.updatePromo(
        promo.id,
        model.toJson(),
      );
      await _localDataSource.cachePromo(updatedModel);
      return Right(updatedModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ [PromoRepositoryImpl.updatePromo] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePromo(String id) async {
    try {
      await _remoteDataSource.deletePromo(id);
      await _localDataSource.deleteCachedPromo(id);
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('❌ [PromoRepositoryImpl.deletePromo] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    try {
      final url = await _remoteDataSource.uploadImage(filePath);
      return Right(url);
    } catch (e, stackTrace) {
      debugPrint('❌ [PromoRepositoryImpl.uploadImage] Error: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
