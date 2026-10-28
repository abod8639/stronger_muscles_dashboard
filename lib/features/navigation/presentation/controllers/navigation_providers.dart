import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/datasources/navigation_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/navigation/data/repositories/navigation_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/repositories/navigation_repository.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/usecases/get_navigation_badges_usecase.dart';
import 'navigation_notifier.dart';
import 'navigation_state.dart';

export 'navigation_notifier.dart';
export 'navigation_state.dart';

// ==================== Data Layer Scoped Providers ====================

/// Scoped provider for Navigation Hive Cache Box
final navigationHiveBoxProvider = Provider<Box>((ref) {
  return Hive.box('navigation_badges');
});

/// Scoped provider for [NavigationLocalDataSource]
final navigationLocalDataSourceProvider =
    Provider<NavigationLocalDataSource>((ref) {
  return NavigationLocalDataSourceImpl(box: ref.watch(navigationHiveBoxProvider));
});

/// Scoped provider for [NavigationRemoteDataSource]
final navigationRemoteDataSourceProvider =
    Provider<NavigationRemoteDataSource>((ref) {
  return NavigationRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// ==================== Domain Layer Scoped Providers ====================

/// Scoped provider for [NavigationRepository] acting as Single Source of Truth
final navigationRepositoryProvider = Provider<NavigationRepository>((ref) {
  return NavigationRepositoryImpl(
    remoteDataSource: ref.watch(navigationRemoteDataSourceProvider),
    localDataSource: ref.watch(navigationLocalDataSourceProvider),
  );
});

/// Scoped provider for [GetNavigationBadgesUseCase]
final getNavigationBadgesUseCaseProvider =
    Provider<GetNavigationBadgesUseCase>((ref) {
  return GetNavigationBadgesUseCase(ref.watch(navigationRepositoryProvider));
});

// ==================== Presentation Layer Scoped Providers ====================

/// Main navigation controller provider managing selection, drawer, and badges
final navigationControllerProvider =
    AsyncNotifierProvider<NavigationNotifier, NavigationState>(
  NavigationNotifier.new,
);

/// Scoped selective provider exposing active tab index without triggering full scaffold rebuilds
final currentNavigationIndexProvider = Provider<int>((ref) {
  return ref.watch(
    navigationControllerProvider.select((s) => s.value?.selectedIndex ?? 0),
  );
});

/// Scoped selective provider exposing badge metrics
final navigationBadgesProvider = Provider<NavigationBadgesEntity>((ref) {
  return ref.watch(
    navigationControllerProvider.select(
      (s) => s.value?.badges ?? const NavigationBadgesEntity.initial(),
    ),
  );
});
