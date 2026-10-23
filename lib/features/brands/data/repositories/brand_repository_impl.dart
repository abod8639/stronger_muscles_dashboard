import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/models/brand_model.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  final Dio dio;

  BrandRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands({CancelToken? cancelToken}) async {
    try {
      final response = await dio.get(
        ApiConfig.adminBrands,
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: const Duration(seconds: 35),
          receiveTimeout: const Duration(seconds: 35),
        ),
      );

      final decoded = response.data;
      dynamic rawList;
      if (decoded is Map && decoded.containsKey('data')) {
        rawList = decoded['data'];
      } else if (decoded is List) {
        rawList = decoded;
      } else {
        rawList = [];
      }

      // عزل فك التشفير والتحليل داخل Isolate
      final brands = await compute(parseBrandListCompute, rawList);
      return Right(brands);
    } catch (e, stackTrace) {
      return Left(NetworkErrorHandler.handleException(e, stackTrace));
    }
  }
}
