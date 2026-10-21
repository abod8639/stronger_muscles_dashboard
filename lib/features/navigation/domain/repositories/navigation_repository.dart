import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/navigation_badges_entity.dart';

abstract class NavigationRepository {
  Future<Either<Failure, NavigationBadgesEntity>> getNavigationBadges({
    CancelToken? cancelToken,
  });
}
