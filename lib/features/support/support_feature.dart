library;

/// Public API Barrel file for the Support & Complaints Feature Module.
/// Adheres strictly to Clean Architecture Rule 2:
/// Exposes only domain entities, repository contracts, usecases, routes, and public UI screens.
/// Internal DataSources, Models, Mappers, and private Widgets remain encapsulated.

// Domain Entities
export 'domain/entities/support_message_entity.dart';
export 'domain/entities/support_stats_entity.dart';
export 'domain/entities/support_ticket_entity.dart';
export 'domain/entities/support_tickets_page_entity.dart';

// Domain Repositories
export 'domain/repositories/support_repository.dart';

// Domain UseCases
export 'domain/usecases/support_usecases.dart';

// Presentation Controllers & Providers
export 'presentation/controllers/support_controller.dart' show SupportNotifier;
export 'presentation/controllers/support_providers.dart';
export 'presentation/controllers/support_state.dart';

// Presentation Pages & Routes
export 'presentation/pages/support_screen.dart';
export 'support_routes.dart';
