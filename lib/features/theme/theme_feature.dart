/// Public barrel file for the Theme feature module.
/// Strictly exposes only Domain Entities, UseCases, Repository contracts,
/// scoped Providers, presentation controllers, and Modular Routes.
/// Internal DataSources, DTO Models, and Mappers remain private.
library;

// Domain Layer — Entities, Contracts & UseCases
export 'domain/entities/app_theme_mode.dart';
export 'domain/entities/theme_entity.dart';
export 'domain/repositories/theme_repository.dart';
export 'domain/usecases/get_theme_usecase.dart';
export 'domain/usecases/set_theme_usecase.dart';
export 'domain/usecases/toggle_theme_usecase.dart';

// Presentation Layer — State & Providers
export 'presentation/controllers/theme_controller.dart';
export 'presentation/controllers/theme_providers.dart';
export 'presentation/controllers/theme_state.dart';

// Routing
export 'theme_routes.dart';
