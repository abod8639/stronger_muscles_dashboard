import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';

class GetPromosUseCase {
  final PromoRepository repository;

  GetPromosUseCase(this.repository);

  Future<Either<Failure, List<PromoEntity>>> call({CancelToken? cancelToken}) async {
    return await repository.getPromos(cancelToken: cancelToken);
  }
}

class AddPromoUseCase {
  final PromoRepository repository;

  AddPromoUseCase(this.repository);

  Future<Either<Failure, PromoEntity>> call(PromoEntity promo, {CancelToken? cancelToken}) async {
    return await repository.addPromo(promo, cancelToken: cancelToken);
  }
}

class UpdatePromoUseCase {
  final PromoRepository repository;

  UpdatePromoUseCase(this.repository);

  Future<Either<Failure, PromoEntity>> call(PromoEntity promo, {CancelToken? cancelToken}) async {
    return await repository.updatePromo(promo, cancelToken: cancelToken);
  }
}

class DeletePromoUseCase {
  final PromoRepository repository;

  DeletePromoUseCase(this.repository);

  Future<Either<Failure, void>> call(String id, {CancelToken? cancelToken}) async {
    return await repository.deletePromo(id, cancelToken: cancelToken);
  }
}

class UploadPromoImageUseCase {
  final PromoRepository repository;

  UploadPromoImageUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath, {CancelToken? cancelToken}) async {
    return await repository.uploadImage(filePath, cancelToken: cancelToken);
  }
}
