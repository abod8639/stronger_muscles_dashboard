/// Public barrel file for the Navigation feature module.
/// Strictly encapsulates internal data sources, DTOs, mappers, and internal presentation widgets.
/// Exposes ONLY public contracts:
/// - Domain Entities: [NavigationTab], [NavigationBadgesEntity]
/// - Domain Repositories: [NavigationRepository]
/// - Domain UseCases: [GetNavigationBadgesUseCase]
/// - Scoped Riverpod Providers: [navigationControllerProvider], [currentNavigationIndexProvider], [navigationBadgesProvider], etc.
/// - Presentation State & Notifiers: [NavigationState], [NavigationNotifier]
/// - Presentation Extensions: [NavigationTabUiExtension]
/// - Public UI Shell: [MainNavigationScreen]
/// - Modular Feature Routes: [NavigationRoutes]
library;

// Domain Entities
export 'domain/entities/navigation_badges_entity.dart';
export 'domain/entities/navigation_tab.dart';

// Domain Repositories
export 'domain/repositories/navigation_repository.dart';

// Domain UseCases
export 'domain/usecases/get_navigation_badges_usecase.dart';

// Scoped Riverpod Providers & State
export 'presentation/controllers/navigation_notifier.dart';
export 'presentation/controllers/navigation_providers.dart';
export 'presentation/controllers/navigation_state.dart';

// Presentation UI Extensions
export 'presentation/utils/navigation_tab_ui_extension.dart';

// Public Shell Screen
export 'presentation/page/main_navigation_screen.dart';

// Modular Feature Routes
export 'navigation_routes.dart';
