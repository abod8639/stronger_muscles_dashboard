import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/navigation_badges_entity.dart';
import '../../domain/repositories/navigation_repository.dart';
import '../datasources/navigation_remote_datasource.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  final NavigationRemoteDataSource remoteDataSource;

  NavigationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NavigationBadgesEntity>> getNavigationBadges({
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getNavigationBadges(
        cancelToken: cancelToken,
      );
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('NavigationRepositoryImpl Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
