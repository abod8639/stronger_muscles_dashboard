/// Public contracts barrel file for the Categories feature.
/// Strictly encapsulates internal data sources, DTOs, mappers, and internal widgets.
library;

// Domain Entities
export 'domain/entities/category_entity.dart';

// Domain Repositories (Pure Contracts)
export 'domain/repositories/category_repository.dart';

// Domain UseCases
export 'domain/usecases/add_category_usecase.dart';
export 'domain/usecases/delete_category_usecase.dart';
export 'domain/usecases/get_categories_usecase.dart';
export 'domain/usecases/get_category_by_id_usecase.dart';
export 'domain/usecases/update_category_usecase.dart';

// Scoped Riverpod Providers & State
export 'presentation/controllers/categories_notifier.dart';
export 'presentation/controllers/categories_providers.dart';
export 'presentation/controllers/categories_state.dart';

// Public Presentation Screens
export 'presentation/page/categories_screen/categories_screen.dart';
export 'presentation/page/category_form_page/category_form_page.dart';

// Modular Feature Routes
export 'categories_routes.dart';
