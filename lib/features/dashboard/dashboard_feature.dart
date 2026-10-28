/// Public barrel file for the Dashboard feature module.
/// Strictly encapsulates internal data sources, DTOs, mappers, and internal presentation widgets.
/// Exposes ONLY public contracts:
/// - Domain Entities: [DashboardStatsEntity]
/// - Domain Repositories: [DashboardRepository]
/// - Domain UseCases: [GetDashboardDataUseCase]
/// - Scoped Riverpod Providers: [dashboardRepositoryProvider], [dashboardStatsNotifierProvider], [ordersChartDataProvider], etc.
/// - Presentation State & Notifiers: [DashboardStatsState], [DashboardStatus], [DashboardStatsNotifier]
/// - Public UI Page: [DashboardPage]
/// - Modular Feature Routes: [DashboardRoutes]
library;

// Domain Entities
export 'domain/entities/dashboard_stats_entity.dart';

// Domain Repositories
export 'domain/repositories/dashboard_repository.dart';

// Domain UseCases
export 'domain/usecases/get_dashboard_data_usecase.dart';

// Scoped Riverpod Providers
export 'presentation/controllers/dashboard_notifier.dart';
export 'presentation/controllers/dashboard_providers.dart';
export 'presentation/controllers/dashboard_state.dart';
export 'presentation/models/orders_chart_data.dart';

// Public Presentation Screens
export 'presentation/pages/dashboard_page.dart';

// Modular Feature Routes
export 'dashboard_routes.dart';
