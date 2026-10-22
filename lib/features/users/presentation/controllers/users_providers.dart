import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api/user_service.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/users_stats_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(ref.watch(userServiceProvider));
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
  @override
  FutureOr<UsersStatsEntity> build() async {
    final useCase = ref.watch(getUsersStatsUseCaseProvider);
    return await useCase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getUsersStatsUseCaseProvider);
      return await useCase();
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
