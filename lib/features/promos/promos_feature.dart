/// Public API of the Promos feature.
/// Strictly exposes only Domain Entities, UseCases, Repository contracts,
/// scoped Providers, public Screens, and Modular Routes.
/// Internal DataSources, DTO Models, Mappers, and internal Widgets remain private.
library;

// Domain Layer — Entities, Contracts & UseCases
export 'domain/entities/promo_entity.dart';
export 'domain/repositories/promo_repository.dart';
export 'domain/usecases/add_promo_usecase.dart';
export 'domain/usecases/delete_promo_usecase.dart';
export 'domain/usecases/get_promos_usecase.dart';
export 'domain/usecases/promo_usecases.dart';
export 'domain/usecases/update_promo_usecase.dart';
export 'domain/usecases/upload_promo_image_usecase.dart';

// Presentation Layer — Providers & Controllers
export 'presentation/controllers/promo_form_controller.dart';
export 'presentation/controllers/promos_controller.dart';
export 'presentation/controllers/promos_providers.dart';

// Presentation Layer — Public Pages & Widgets
export 'presentation/pages/promo_form_screen.dart';
export 'presentation/pages/promos_screen.dart';
export 'presentation/widgets/promo_app_banner_preview.dart';
export 'presentation/widgets/promo_card.dart';

// Routing
export 'promos_routes.dart';
