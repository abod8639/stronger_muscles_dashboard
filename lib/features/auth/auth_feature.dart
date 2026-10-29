// Public Barrel File for the Authentication Feature Module.
//
// Encapsulates the module internals (DataSources, Models, Mappers, and Internal Widgets).
// Exposes ONLY public contracts:
// - Domain Entities: [AuthEntity]
// - Domain Repositories: [AuthRepository]
// - Domain UseCases: [LoginUseCase], [SignupUseCase], [LogoutUseCase], [CheckAuthStatusUseCase], [GetCurrentUserUseCase]
// - Public Scoped Providers: [authControllerProvider], [authRepositoryProvider], etc.
// - Presentation State: [AuthState], [AuthStatus]
// - Modular Feature Routes: [AuthRoutes]

// Domain Entities
export 'domain/entities/auth_entity.dart';

// Domain Repositories
export 'domain/repositories/auth_repository.dart';

// Domain UseCases
export 'domain/usecases/check_auth_status_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/signup_usecase.dart';

// Presentation State & Providers
export 'presentation/controllers/auth_state.dart';
export 'presentation/controllers/auth_providers.dart';

// Modular Routes
export 'auth_routes.dart';
