import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource remoteDataSource;

  PromoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromos({CancelToken? cancelToken}) async {
    try {
      final models = await remoteDataSource.getPromos(cancelToken: cancelToken);
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (e, stackTrace) {
      debugPrint('PromoRepositoryImpl (getPromos) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, PromoEntity>> addPromo(PromoEntity promo, {CancelToken? cancelToken}) async {
    try {
      final model = PromoModel.fromEntity(promo);
      final addedModel = await remoteDataSource.addPromo(model.toJson(), cancelToken: cancelToken);
      return Right(addedModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('PromoRepositoryImpl (addPromo) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, PromoEntity>> updatePromo(PromoEntity promo, {CancelToken? cancelToken}) async {
    try {
      final model = PromoModel.fromEntity(promo);
      final updatedModel = await remoteDataSource.updatePromo(promo.id, model.toJson(), cancelToken: cancelToken);
      return Right(updatedModel.toEntity());
    } catch (e, stackTrace) {
      debugPrint('PromoRepositoryImpl (updatePromo) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deletePromo(String id, {CancelToken? cancelToken}) async {
    try {
      await remoteDataSource.deletePromo(id, cancelToken: cancelToken);
      return const Right(null);
    } catch (e, stackTrace) {
      debugPrint('PromoRepositoryImpl (deletePromo) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath, {CancelToken? cancelToken}) async {
    try {
      final url = await remoteDataSource.uploadImage(filePath, cancelToken: cancelToken);
      return Right(url);
    } catch (e, stackTrace) {
      debugPrint('PromoRepositoryImpl (uploadImage) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
