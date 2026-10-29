import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/users/data/datasources/user_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/users/data/datasources/user_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/users_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/repositories/user_repository_impl.dart';

class FakeUserRemoteDataSource implements UserRemoteDataSource {
  UsersStatsModel? statsResponse;
  List<UserModel>? usersResponse;
  Exception? errorToThrow;
  int getUsersStatsCallCount = 0;
  int getUsersCallCount = 0;

  @override
  Future<UsersStatsModel> getUsersStats({CancelToken? cancelToken}) async {
    getUsersStatsCallCount++;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return statsResponse ??
        const UsersStatsModel(
          totalUsers: 1,
          activeUsers: 1,
          inactiveUsers: 0,
          users: [],
        );
  }

  @override
  Future<List<UserModel>> getUsers({CancelToken? cancelToken}) async {
    getUsersCallCount++;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return usersResponse ?? [];
  }
}

class FakeUserLocalDataSource implements UserLocalDataSource {
  UsersStatsModel? cachedStats;
  List<UserModel> cachedUsers = [];
  bool cacheValid = false;
  int cacheStatsCallCount = 0;
  int cacheUsersCallCount = 0;

  @override
  Future<void> cacheUsersStats(UsersStatsModel stats) async {
    cacheStatsCallCount++;
    cachedStats = stats;
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    cacheUsersCallCount++;
    cachedUsers = List.from(users);
  }

  @override
  Future<void> clearCache() async {
    cachedStats = null;
    cachedUsers.clear();
  }

  @override
  Future<UsersStatsModel?> getCachedUsersStats() async => cachedStats;

  @override
  Future<List<UserModel>> getCachedUsers() async => cachedUsers;

  @override
  Future<bool> isStatsCacheValid() async => cacheValid;
}

void main() {
  late FakeUserRemoteDataSource fakeRemote;
  late FakeUserLocalDataSource fakeLocal;
  late UserRepositoryImpl repository;

  final testUserModel = const UserModel(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    role: 'customer',
    isActive: true,
  );

  final testStatsModel = UsersStatsModel(
    totalUsers: 1,
    activeUsers: 1,
    inactiveUsers: 0,
    users: [testUserModel],
  );

  setUp(() {
    fakeRemote = FakeUserRemoteDataSource();
    fakeLocal = FakeUserLocalDataSource();
    repository = UserRepositoryImpl(
      remoteDataSource: fakeRemote,
      localDataSource: fakeLocal,
    );
  });

  group('getUsersStats', () {
    test('returns cached data when cache is valid and forceRefresh is false', () async {
      fakeLocal.cachedStats = testStatsModel;
      fakeLocal.cacheValid = true;

      final result = await repository.getUsersStats();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (stats) {
          expect(stats.totalUsers, 1);
          expect(stats.users.first.name, 'Test User');
        },
      );
      expect(fakeRemote.getUsersStatsCallCount, 0);
    });

    test('calls remote and updates cache when cache is invalid', () async {
      fakeLocal.cacheValid = false;
      fakeRemote.statsResponse = testStatsModel;

      final result = await repository.getUsersStats();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (stats) => expect(stats.totalUsers, 1),
      );
      expect(fakeRemote.getUsersStatsCallCount, 1);
      expect(fakeLocal.cacheStatsCallCount, 1);
      expect(fakeLocal.cacheUsersCallCount, 1);
    });

    test('bypasses valid cache when forceRefresh is true', () async {
      fakeLocal.cachedStats = testStatsModel;
      fakeLocal.cacheValid = true;
      fakeRemote.statsResponse = testStatsModel;

      final result = await repository.getUsersStats(forceRefresh: true);

      expect(result.isRight(), true);
      expect(fakeRemote.getUsersStatsCallCount, 1);
    });

    test('falls back to cache when remote fails and cached data exists', () async {
      fakeLocal.cacheValid = false;
      fakeLocal.cachedStats = testStatsModel;
      fakeRemote.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/admin/users'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await repository.getUsersStats();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should return cached data on fallback'),
        (stats) => expect(stats.totalUsers, 1),
      );
    });

    test('returns Left(Failure) when remote fails and no cache exists', () async {
      fakeLocal.cacheValid = false;
      fakeLocal.cachedStats = null;
      fakeRemote.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/admin/users'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await repository.getUsersStats();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (stats) => fail('Should fail'),
      );
    });
  });

  group('getUsers', () {
    test('returns cached users when cache has data and not force refreshing', () async {
      fakeLocal.cachedUsers = [testUserModel];

      final result = await repository.getUsers();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (users) {
          expect(users.length, 1);
          expect(users.first.name, 'Test User');
        },
      );
      expect(fakeRemote.getUsersCallCount, 0);
    });

    test('calls remote and caches when local users are empty', () async {
      fakeLocal.cachedUsers = [];
      fakeRemote.usersResponse = [testUserModel];

      final result = await repository.getUsers();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should succeed'),
        (users) => expect(users.length, 1),
      );
      expect(fakeRemote.getUsersCallCount, 1);
      expect(fakeLocal.cacheUsersCallCount, 1);
    });

    test('returns Left(Failure) on remote failure when no cached users exist', () async {
      fakeLocal.cachedUsers = [];
      fakeRemote.errorToThrow = DioException(
        requestOptions: RequestOptions(path: '/admin/users'),
        type: DioExceptionType.badResponse,
      );

      final result = await repository.getUsers();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (users) => fail('Should fail'),
      );
    });
  });
}
