import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/models/navigation_badges_model.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/repositories/navigation_repository_impl.dart';

class MockNavigationLocalDataSource implements NavigationLocalDataSource {
  NavigationBadgesModel? cachedBadges;
  bool cacheValid = false;

  @override
  Future<NavigationBadgesModel?> getCachedBadges() async => cachedBadges;

  @override
  Future<void> cacheBadges(NavigationBadgesModel badges) async {
    cachedBadges = badges;
    cacheValid = true;
  }

  @override
  Future<bool> isCacheValid() async => cacheValid;

  @override
  Future<void> clearCache() async {
    cachedBadges = null;
    cacheValid = false;
  }
}

class MockNavigationRemoteDataSource implements NavigationRemoteDataSource {
  NavigationBadgesModel? remoteBadges;
  Exception? exceptionToThrow;

  @override
  Future<NavigationBadgesModel> getNavigationBadges() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteBadges ?? const NavigationBadgesModel();
  }
}

void main() {
  late MockNavigationLocalDataSource localDataSource;
  late MockNavigationRemoteDataSource remoteDataSource;
  late NavigationRepositoryImpl repository;

  setUp(() {
    localDataSource = MockNavigationLocalDataSource();
    remoteDataSource = MockNavigationRemoteDataSource();
    repository = NavigationRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('NavigationRepositoryImpl Tests', () {
    test('returns cached badges immediately when cache is valid and forceRefresh is false', () async {
      const cached = NavigationBadgesModel(
        pendingOrdersCount: 5,
        unreadNotificationsCount: 3,
        openTicketsCount: 1,
        lowStockProductsCount: 2,
      );
      localDataSource.cachedBadges = cached;
      localDataSource.cacheValid = true;

      final result = await repository.getNavigationBadges(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (entity) {
          expect(entity.pendingOrdersCount, 5);
          expect(entity.unreadNotificationsCount, 3);
          expect(entity.openTicketsCount, 1);
          expect(entity.lowStockProductsCount, 2);
        },
      );
    });

    test('fetches from remote data source and updates cache when forceRefresh is true', () async {
      const remote = NavigationBadgesModel(
        pendingOrdersCount: 12,
        unreadNotificationsCount: 8,
        openTicketsCount: 4,
        lowStockProductsCount: 7,
      );
      remoteDataSource.remoteBadges = remote;

      final result = await repository.getNavigationBadges(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (entity) {
          expect(entity.pendingOrdersCount, 12);
          expect(entity.unreadNotificationsCount, 8);
        },
      );
      expect(localDataSource.cachedBadges?.pendingOrdersCount, 12);
      expect(localDataSource.cacheValid, isTrue);
    });

    test('falls back gracefully to stale cache on network exception', () async {
      localDataSource.cachedBadges = const NavigationBadgesModel(
        pendingOrdersCount: 2,
        unreadNotificationsCount: 1,
      );
      localDataSource.cacheValid = false;
      remoteDataSource.exceptionToThrow = ServerException(message: 'Connection timed out');

      final result = await repository.getNavigationBadges(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right fallback, got Left: $failure'),
        (entity) {
          expect(entity.pendingOrdersCount, 2);
        },
      );
    });

    test('returns Left(Failure) when remote fails and no local cache exists', () async {
      localDataSource.cachedBadges = null;
      localDataSource.cacheValid = false;
      remoteDataSource.exceptionToThrow = ServerException(message: 'Fatal server error');

      final result = await repository.getNavigationBadges(forceRefresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure.message, contains('Fatal server error')),
        (_) => fail('Expected Left, got Right'),
      );
    });
  });
}
