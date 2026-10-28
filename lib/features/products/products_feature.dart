// Public Barrel File for Products Feature
// Exposes only public contracts, entities, usecases, routes, and main controllers.

export 'domain/entities/product_entity.dart';
export 'domain/repositories/product_repository.dart';
export 'domain/usecases/add_product_usecase.dart';
export 'domain/usecases/delete_product_usecase.dart';
export 'domain/usecases/get_product_by_id_usecase.dart';
export 'domain/usecases/get_products_usecase.dart';
export 'domain/usecases/update_product_usecase.dart';
export 'domain/usecases/upload_product_image_usecase.dart';
export 'presentation/controllers/products_controller.dart';
export 'presentation/controllers/products_notifier.dart';
export 'presentation/controllers/products_providers.dart';
export 'presentation/pages/products_screen.dart';
export 'presentation/widgets/category_tree_selector.dart';
export 'presentation/widgets/product_form_page.dart';
export 'products_routes.dart';
