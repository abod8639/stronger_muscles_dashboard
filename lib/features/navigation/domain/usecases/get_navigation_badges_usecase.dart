import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/navigation_badges_entity.dart';
import '../repositories/navigation_repository.dart';

/// Pure Dart UseCase for retrieving Navigation badges.
/// Encapsulates the execution logic for retrieving badge counters.
class GetNavigationBadgesUseCase {
  final NavigationRepository _repository;

  const GetNavigationBadgesUseCase(this._repository);

  Future<Either<Failure, NavigationBadgesEntity>> call({
    bool forceRefresh = false,
  }) {
    return _repository.getNavigationBadges(forceRefresh: forceRefresh);
  }
}
