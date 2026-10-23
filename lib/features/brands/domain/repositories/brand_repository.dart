import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';

abstract class BrandRepository {
  Future<Either<Failure, List<BrandEntity>>> getBrands({CancelToken? cancelToken});
}
