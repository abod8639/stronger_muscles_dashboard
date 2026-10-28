import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';

enum DashboardStatus { initial, loading, success, error }

/// Immutable state model for the Dashboard feature.
class DashboardStatsState {
  final DashboardStatus status;
  final DashboardStatsEntity stats;
  final String selectedPeriod;
  final String? errorMessage;
  final bool isRefreshing;

  const DashboardStatsState({
    this.status = DashboardStatus.initial,
    this.stats = const DashboardStatsEntity.initial(),
    this.selectedPeriod = 'week',
    this.errorMessage,
    this.isRefreshing = false,
  });

  bool get isLoading => status == DashboardStatus.loading;
  bool get hasError => status == DashboardStatus.error && errorMessage != null;
  bool get isEmpty =>
      status == DashboardStatus.success &&
      stats.orders.isEmpty &&
      stats.products.isEmpty;

  DashboardStatsState copyWith({
    DashboardStatus? status,
    DashboardStatsEntity? stats,
    String? selectedPeriod,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return DashboardStatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
