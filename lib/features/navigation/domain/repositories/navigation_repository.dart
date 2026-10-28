import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/navigation_badges_entity.dart';

/// Pure Dart Repository Contract for the Navigation feature.
/// 100% pure Dart: zero imports from Flutter UI, Dio, Hive, or 3rd-party SDKs.
abstract class NavigationRepository {
  Future<Either<Failure, NavigationBadgesEntity>> getNavigationBadges({
    bool forceRefresh = false,
  });
}
