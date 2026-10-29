import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'dashboard_providers.dart';

/// State Notifier orchestrating dashboard aggregate data loading and refreshing.
/// Adheres to Clean Architecture:
/// - Pure constructor dependency injection (100% testable without global singletons)
/// - Zero try-catch blocks (functional Either handling via fpdart)
class DashboardStatsNotifier extends AsyncNotifier<DashboardStatsEntity> {
  final GetDashboardDataUseCase? _injectedUseCase;

  DashboardStatsNotifier([this._injectedUseCase]);

  @override
  Future<DashboardStatsEntity> build() async {
    final GetDashboardDataUseCase useCase =
        _injectedUseCase ?? ref.watch(getDashboardDataUseCaseProvider);
    final result = await useCase();

    return result.fold((failure) => throw failure, (stats) => stats);
  }

  /// Reloads dashboard data with fresh remote fetch, bypassing local cache
  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    final GetDashboardDataUseCase useCase =
        _injectedUseCase ?? ref.read(getDashboardDataUseCaseProvider);
    final result = await useCase(forceRefresh: true);

    if (ref.mounted) {
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (stats) => AsyncValue.data(stats),
      );
    }
  }
}
