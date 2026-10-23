import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';

abstract class PromoRepository {
  Future<Either<Failure, List<PromoEntity>>> getPromos({CancelToken? cancelToken});
  Future<Either<Failure, PromoEntity>> addPromo(PromoEntity promo, {CancelToken? cancelToken});
  Future<Either<Failure, PromoEntity>> updatePromo(PromoEntity promo, {CancelToken? cancelToken});
  Future<Either<Failure, void>> deletePromo(String id, {CancelToken? cancelToken});
  Future<Either<Failure, String>> uploadImage(String filePath, {CancelToken? cancelToken});
}
