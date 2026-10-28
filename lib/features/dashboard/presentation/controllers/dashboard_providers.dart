import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/models/orders_chart_data.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/utils/dashboard_chart_calculator.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import 'package:stronger_muscles_dashboard/features/users/users_feature.dart';
import 'dashboard_notifier.dart';

// ==================== Data Layer Scoped Providers ====================

/// Scoped provider for Dashboard Hive Cache Box
final dashboardHiveBoxProvider = Provider<Box>((ref) {
  return Hive.box('dashboard_stats');
});

/// Scoped provider for [DashboardLocalDataSource]
final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((ref) {
  return DashboardLocalDataSourceImpl(box: ref.watch(dashboardHiveBoxProvider));
});

/// Scoped provider for [DashboardRemoteDataSource]
final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// ==================== Domain Layer Scoped Providers ====================

/// Scoped provider for [DashboardRepository] acting as Single Source of Truth
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    orderRepository: ref.watch(orderRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
    localDataSource: ref.watch(dashboardLocalDataSourceProvider),
    remoteDataSource: ref.watch(dashboardRemoteDataSourceProvider),
  );
});

/// Scoped provider for [GetDashboardDataUseCase]
final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

// ==================== Presentation Layer Scoped Providers ====================

const List<Map<String, String>> dashboardPeriodItems = [
  {'id': 'week', 'name': 'هذا الأسبوع'},
  {'id': 'month', 'name': 'هذا الشهر'},
  {'id': 'year', 'name': 'هذا العام'},
];

/// Notifier managing current dashboard time window filter ('week' | 'month' | 'year')
class DashboardPeriodNotifier extends Notifier<String> {
  @override
  String build() => 'week';

  void setPeriod(String period) => state = period;
}

final dashboardPeriodProvider =
    NotifierProvider<DashboardPeriodNotifier, String>(DashboardPeriodNotifier.new);

/// State notifier provider managing dashboard entity lifecycle
final dashboardStatsNotifierProvider =
    AsyncNotifierProvider<DashboardStatsNotifier, DashboardStatsEntity>(
  DashboardStatsNotifier.new,
);

/// Scoped reactive provider calculating order graph points based on active period filter
final ordersChartDataProvider = Provider<OrdersChartData>((ref) {
  final stats = ref.watch(dashboardStatsNotifierProvider).value ??
      const DashboardStatsEntity.initial();
  final period = ref.watch(dashboardPeriodProvider);
  return DashboardChartCalculator.calculateOrdersChartData(stats.orders, period);
});

/// Scoped family provider calculating percentage trend and sparklines per order status
final statusTrendDataProvider =
    Provider.family<IndicatorTrendData, OrderStatus>((ref, status) {
  final stats = ref.watch(dashboardStatsNotifierProvider).value ??
      const DashboardStatsEntity.initial();
  final period = ref.watch(dashboardPeriodProvider);
  return DashboardChartCalculator.calculateStatusTrendData(stats.orders, status, period);
});
