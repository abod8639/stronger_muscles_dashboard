/// Public Barrel File for the Orders Feature.
///
/// Exposes strictly public contracts (Entities, UseCases, Providers, Routes, and Pages)
/// while encapsulating internal data sources, DTO models, and private implementation details.
library;

// Domain Entities & Enums
export 'domain/entities/address_entity.dart';
export 'domain/entities/order_entity.dart';

// Domain Repositories (Interface)
export 'domain/repositories/order_repository.dart';

// Domain UseCases
export 'domain/usecases/get_order_detail_usecase.dart';
export 'domain/usecases/get_orders_usecase.dart';
export 'domain/usecases/update_order_status_usecase.dart';

// Presentation State, Notifiers & Providers
export 'presentation/controllers/orders_providers.dart';

// Modular Routing
export 'orders_routes.dart';

// Presentation Public Pages & Components
export 'presentation/pages/order_details_screen/order_details_screen.dart';
export 'presentation/pages/orders_page.dart';
export 'presentation/widgets/order_list_tile.dart';
