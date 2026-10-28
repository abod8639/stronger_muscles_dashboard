import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_stats_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to fetch high-level support analytics and metrics.
class GetSupportStatsUseCase {
  final SupportRepository _repository;

  const GetSupportStatsUseCase(this._repository);

  Future<Either<Failure, SupportStatsEntity>> call() {
    return _repository.getStats();
  }
}
