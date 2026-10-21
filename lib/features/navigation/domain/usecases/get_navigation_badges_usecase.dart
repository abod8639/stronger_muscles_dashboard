import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/navigation_badges_entity.dart';
import '../repositories/navigation_repository.dart';

class GetNavigationBadgesUseCase {
  final NavigationRepository repository;

  GetNavigationBadgesUseCase(this.repository);

  Future<Either<Failure, NavigationBadgesEntity>> call({
    CancelToken? cancelToken,
  }) async {
    return await repository.getNavigationBadges(cancelToken: cancelToken);
  }
}
