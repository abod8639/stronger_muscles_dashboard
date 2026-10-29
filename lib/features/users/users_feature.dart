/// Public barrel file for Users feature module.
library;

// Domain Entities
export 'domain/entities/user_address_entity.dart';
export 'domain/entities/user_entity.dart';
export 'domain/entities/users_stats_entity.dart';

// Domain Repositories & UseCases
export 'domain/repositories/user_repository.dart';
export 'domain/usecases/get_users_stats_usecase.dart';
export 'domain/usecases/get_users_usecase.dart';

// Presentation Providers & Pages
export 'presentation/controllers/users_providers.dart';
export 'presentation/pages/users_page.dart';

// Modular Routes
export 'users_routes.dart';
