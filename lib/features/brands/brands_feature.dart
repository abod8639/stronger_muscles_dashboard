// Public Barrel File for the Brands Feature Module.
//
// Encapsulates the module internals (DataSources, Models, Mappers, and Internal Widgets).
// Exposes ONLY public contracts:
// - Domain Entities: [BrandEntity]
// - Domain Repositories: [BrandRepository]
// - Domain UseCases: [GetBrandsUseCase], [GetBrandByIdUseCase]
// - Public Scoped Providers: [brandRepositoryProvider], [brandsNotifierProvider], [brandsListProvider]
// - Presentation State: [BrandsState], [BrandsStatus]
// - Modular Feature Routes: [BrandsRoutes]

// Domain Entities
export 'domain/entities/brand_entity.dart';

// Domain Repositories
export 'domain/repositories/brand_repository.dart';

// Domain UseCases
export 'domain/usecases/get_brands_usecase.dart';
export 'domain/usecases/get_brand_by_id_usecase.dart';

// Presentation State
export 'presentation/controllers/brands_state.dart';

// Public Scoped Dependency Injection Providers
export 'presentation/controllers/brands_providers.dart'
    show
        brandRepositoryProvider,
        brandsNotifierProvider,
        brandsListProvider,
        getBrandsUseCaseProvider,
        getBrandByIdUseCaseProvider;

// Modular Routes
export 'brands_routes.dart';
