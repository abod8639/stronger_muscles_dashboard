import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';

// ==================== Data Layer Scoped Providers ====================

final usersStatsHiveBoxProvider = Provider<Box>((ref) {
  return Hive.box('users_stats_cache');
});

final usersHiveBoxProvider = Provider<Box<UserModel>>((ref) {
  return Hive.box<UserModel>('users');
});

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSourceImpl(
    statsBox: ref.watch(usersStatsHiveBoxProvider),
    usersBox: ref.watch(usersHiveBoxProvider),
  );
});

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRemoteDataSourceImpl(dio);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    localDataSource: ref.watch(userLocalDataSourceProvider),
  );
});

// ==================== Domain Layer UseCases Providers ====================

final getUsersStatsUseCaseProvider = Provider<GetUsersStatsUseCase>((ref) {
  return GetUsersStatsUseCase(ref.watch(userRepositoryProvider));
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  return GetUsersUseCase(ref.watch(userRepositoryProvider));
});

// ==================== Presentation Search Query Notifier ====================

class UsersSearchQueryNotifier extends Notifier<String> {
  Timer? _debounceTimer;

  @override
  String build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return '';
  }

  void setQuery(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      state = query;
    });
  }

  void setQueryImmediately(String query) {
    _debounceTimer?.cancel();
    state = query;
  }
}

final usersSearchQueryProvider =
    NotifierProvider<UsersSearchQueryNotifier, String>(
  UsersSearchQueryNotifier.new,
);

// ==================== Presentation Main Users Notifier ====================

class UsersNotifier extends AsyncNotifier<UsersStatsEntity> {
  final GetUsersStatsUseCase? _injectedUseCase;

  UsersNotifier({GetUsersStatsUseCase? getUsersStatsUseCase})
      : _injectedUseCase = getUsersStatsUseCase;

  @override
  FutureOr<UsersStatsEntity> build() async {
    final GetUsersStatsUseCase useCase =
        _injectedUseCase ?? ref.watch(getUsersStatsUseCaseProvider);
    final result = await useCase();

    return result.fold(
      (failure) => throw failure,
      (stats) => stats,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final GetUsersStatsUseCase useCase =
        _injectedUseCase ?? ref.read(getUsersStatsUseCaseProvider);
    final result = await useCase(forceRefresh: true);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (stats) => AsyncData(stats),
    );
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

// ==================== Filtered Users Provider ====================

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
