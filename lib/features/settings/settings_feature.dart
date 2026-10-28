/// Public barrel file for the Settings feature module.
/// Strictly exposes only Domain Entities, UseCases, Repository contracts,
/// scoped Providers, public Screens, and Modular Routes.
/// Internal DataSources, DTO Models, and Mappers remain private.
library;

// Domain Layer — Entities, Contracts & UseCases
export 'domain/entities/settings_entity.dart';
export 'domain/repositories/settings_repository.dart';
export 'domain/usecases/clear_app_cache_usecase.dart';
export 'domain/usecases/get_settings_usecase.dart';
export 'domain/usecases/update_settings_usecase.dart';

// Presentation Layer — State & Providers
export 'presentation/controllers/settings_controller.dart';
export 'presentation/controllers/settings_providers.dart';
export 'presentation/controllers/settings_state.dart';

// Presentation Layer — Public Pages
export 'presentation/page/settings_screen.dart';

// Routing
export 'settings_routes.dart';
