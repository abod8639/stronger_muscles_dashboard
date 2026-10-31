import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import '../../data/datasources/product_local_datasource.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import 'products_controller.dart';
import 'products_notifier.dart';

export 'products_controller.dart';
export 'products_notifier.dart';

// ==========================================
// Data & Local Cache Providers
// ==========================================

/// Hive Box Provider for Products Caching
final productBoxProvider = Provider<Box<ProductModel>>((ref) {
  return Hive.box<ProductModel>('products');
});

/// Local DataSource Provider
final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  final box = ref.watch(productBoxProvider);
  return ProductLocalDataSourceImpl(box);
});

/// Remote DataSource Provider
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
});

// ==========================================
// Repository Provider (Single Source of Truth)
// ==========================================

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remote = ref.watch(productRemoteDataSourceProvider);
  final local = ref.watch(productLocalDataSourceProvider);
  return ProductRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

// ==========================================
// UseCase Providers
// ==========================================

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});

final addProductUseCaseProvider = Provider<AddProductUseCase>((ref) {
  return AddProductUseCase(ref.watch(productRepositoryProvider));
});

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>((ref) {
  return UpdateProductUseCase(ref.watch(productRepositoryProvider));
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  return DeleteProductUseCase(ref.watch(productRepositoryProvider));
});

final uploadProductImageUseCaseProvider = Provider<UploadProductImageUseCase>((
  ref,
) {
  return UploadProductImageUseCase(ref.watch(productRepositoryProvider));
});

// ==========================================
// Search & Filter State Notifiers
// ==========================================

class ProductsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final productsSearchQueryProvider =
    NotifierProvider<ProductsSearchQueryNotifier, String>(
      ProductsSearchQueryNotifier.new,
    );

class ProductsSelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setCategory(String categoryId) => state = categoryId;
}

final productsSelectedCategoryProvider =
    NotifierProvider<ProductsSelectedCategoryNotifier, String>(
      ProductsSelectedCategoryNotifier.new,
    );

class ProductsSelectedFlavorNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setFlavor(String flavor) => state = flavor;
}

final productsSelectedFlavorProvider =
    NotifierProvider<ProductsSelectedFlavorNotifier, String>(
      ProductsSelectedFlavorNotifier.new,
    );

// ==========================================
// Core Products State via AsyncNotifier
// ==========================================

final productsControllerProvider =
    AsyncNotifierProvider<ProductsNotifier, List<ProductEntity>>(
      ProductsNotifier.new,
    );

// ==========================================
// UI Form & Presentation Controller
// ==========================================

final productsUIControllerProvider = Provider<ProductsController>((ref) {
  final addProductUseCase = ref.watch(addProductUseCaseProvider);
  final updateProductUseCase = ref.watch(updateProductUseCaseProvider);
  final deleteProductUseCase = ref.watch(deleteProductUseCaseProvider);
  final uploadProductImageUseCase = ref.watch(
    uploadProductImageUseCaseProvider,
  );
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  final brandRepository = ref.watch(brandRepositoryProvider);

  final controller = ProductsController(
    addProductUseCase: addProductUseCase,
    updateProductUseCase: updateProductUseCase,
    deleteProductUseCase: deleteProductUseCase,
    uploadProductImageUseCase: uploadProductImageUseCase,
    categoryRepository: categoryRepository,
    brandRepository: brandRepository,
  );

  // Sync with Riverpod state updates
  ref.listen<AsyncValue<List<ProductEntity>>>(productsControllerProvider, (
    _,
    next,
  ) {
    next.whenData((products) {
      controller.syncWithRiverpod(products);
    });
  }, fireImmediately: true);

  ref.onDispose(controller.dispose);
  return controller;
});

// ==========================================
// Computed Selectors / Providers
// ==========================================

final filteredProductsProvider = Provider<List<ProductEntity>>((ref) {
  final productsAsync = ref.watch(productsControllerProvider);
  final query = ref.watch(productsSearchQueryProvider).toLowerCase().trim();
  final selectedCat = ref.watch(productsSelectedCategoryProvider);
  final selectedFlavor = ref.watch(productsSelectedFlavorProvider);

  return productsAsync.maybeWhen(
    data: (products) {
      Iterable<ProductEntity> result = products;

      if (selectedCat != 'all') {
        result = result.where((p) => p.categoryId == selectedCat);
      }

      if (selectedFlavor != 'all') {
        result = result.where(
          (p) =>
              p.flavors?.any((f) {
                final clean =
                    f.contains('|') ? f.split('|').first.trim() : f.trim();
                return clean.toLowerCase() == selectedFlavor.toLowerCase();
              }) ??
              false,
        );
      }

      if (query.isNotEmpty) {
        result = result.where(
          (p) =>
              p.nameAr.toLowerCase().contains(query) ||
              p.nameEn.toLowerCase().contains(query) ||
              (p.brand != null && p.brand!.toLowerCase().contains(query)) ||
              p.id.contains(query),
        );
      }

      return result.toList();
    },
    orElse: () => const [],
  );
});
