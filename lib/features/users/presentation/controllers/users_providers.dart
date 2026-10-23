import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRemoteDataSourceImpl(dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));
});

final getUsersStatsUseCaseProvider = Provider<GetUsersStatsUseCase>((ref) {
  return GetUsersStatsUseCase(ref.watch(userRepositoryProvider));
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  return GetUsersUseCase(ref.watch(userRepositoryProvider));
});

final usersSearchQueryProvider = NotifierProvider<UsersSearchQueryNotifier, String>(
  UsersSearchQueryNotifier.new,
);

class UsersSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

class UsersNotifier extends AsyncNotifier<UsersStatsEntity> {
  CancelToken? _cancelToken;

  @override
  FutureOr<UsersStatsEntity> build() async {
    ref.onDispose(() {
      if (_cancelToken != null && !_cancelToken!.isCancelled) {
        _cancelToken!.cancel('cancelled by riverpod onDispose');
      }
    });
    return _fetchStats();
  }

  Future<UsersStatsEntity> _fetchStats() async {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('new request');
    }
    _cancelToken = CancelToken();

    final useCase = ref.watch(getUsersStatsUseCaseProvider);
    final result = await useCase(cancelToken: _cancelToken);

    return result.fold(
      (failure) => throw Exception(failure.toMessage()),
      (stats) => stats,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      _cancelToken?.cancel('new refresh request');
      _cancelToken = CancelToken();

      final useCase = ref.read(getUsersStatsUseCaseProvider);
      final result = await useCase(cancelToken: _cancelToken);

      return result.fold(
        (failure) => throw Exception(failure.toMessage()),
        (stats) => stats,
      );
    });
  }

  void updateUserInfo(UserEntity updatedUser) {
    state.whenData((stats) {
      final updatedList = stats.users.map((u) {
        return u.id == updatedUser.id ? updatedUser : u;
      }).toList();
      state = AsyncData(stats.copyWith(users: updatedList));
    });
  }
}

final usersNotifierProvider =
    AsyncNotifierProvider<UsersNotifier, UsersStatsEntity>(UsersNotifier.new);

/// قائمة المستخدمين المفلترة بحسب نص البحث
final filteredUsersProvider = Provider<List<UserEntity>>((ref) {
  final usersState = ref.watch(usersNotifierProvider);
  final query = ref.watch(usersSearchQueryProvider).trim().toLowerCase();

  return usersState.maybeWhen(
    data: (stats) {
      if (query.isEmpty) return stats.users;
      return stats.users.where((user) {
        final nameMatch = user.name.toLowerCase().contains(query);
        final emailMatch = user.email?.toLowerCase().contains(query) ?? false;
        final phoneMatch = user.phoneNumber?.contains(query) ?? false;
        return nameMatch || emailMatch || phoneMatch;
      }).toList();
    },
    orElse: () => const [],
  );
});
