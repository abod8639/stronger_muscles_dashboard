import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/brands/presentation/controllers/brands_providers.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import 'products_controller.dart';

// ==========================================
// Data & Domain Providers
// ==========================================

/// موفر مصدر بيانات المنتجات البعيد
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
});

/// موفر مستودع المنتجات
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفرات حالات الاستخدام
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
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

final uploadProductImageUseCaseProvider = Provider<UploadProductImageUseCase>((ref) {
  return UploadProductImageUseCase(ref.watch(productRepositoryProvider));
});

// ==========================================
// Search & Filter State Notifiers
// ==========================================

/// موفر نص البحث في المنتجات
class ProductsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final productsSearchQueryProvider =
    NotifierProvider<ProductsSearchQueryNotifier, String>(
  ProductsSearchQueryNotifier.new,
);

/// موفر تصفية التصنيف المحدد ('all' أو معرّف التصنيف)
class ProductsSelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setCategory(String categoryId) => state = categoryId;
}

final productsSelectedCategoryProvider =
    NotifierProvider<ProductsSelectedCategoryNotifier, String>(
  ProductsSelectedCategoryNotifier.new,
);

/// موفر تصفية النكهة المحددة ('all' أو اسم النكهة)
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

/// متحكم حالة المنتجات الرئيسي عبر [AsyncNotifier]
/// يدعم إدارة الإلغاء عبر `ref.onDispose` لمنع تسريب الموارد
/// ويحول الـ `Either<Failure, T>` بأمان إلى `AsyncValue` لمنع تجميد أو انهيار الشاشة
class ProductsNotifier extends AsyncNotifier<List<ProductEntity>> {
  CancelToken? _cancelToken;

  @override
  FutureOr<List<ProductEntity>> build() {
    ref.onDispose(() {
      _cancelToken?.cancel('تم تفريغ ProductsNotifier وإلغاء الطلبات النشطة');
      _cancelToken = null;
    });

    return _fetchProducts(forceRefresh: false);
  }

  Future<List<ProductEntity>> _fetchProducts({bool forceRefresh = false}) async {
    _cancelToken?.cancel('طلب جديد لقائمة المنتجات');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final getProducts = ref.read(getProductsUseCaseProvider);
    final result = await getProducts(
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );

    return result.fold(
      (failure) => throw failure,
      (products) => products,
    );
  }

  /// إعادة تحميل المنتجات مع إجبار تحديث الـ Cache
  Future<void> refreshProducts({bool forceRefresh = true}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchProducts(forceRefresh: forceRefresh),
    );
  }

  /// إضافة منتج جديد وتحديث الحالة محلياً
  Future<Either<Failure, ProductEntity>> addProduct(Map<String, dynamic> data) async {
    final addUseCase = ref.read(addProductUseCaseProvider);
    final previous = state;

    final result = await addUseCase(data);

    result.fold(
      (failure) {},
      (newProduct) {
        final current = List<ProductEntity>.from(previous.value ?? const []);
        final updated = [newProduct, ...current];
        state = AsyncValue.data(updated);
      },
    );

    return result;
  }

  /// تحديث منتج موجود ومزامنة القوائم
  Future<Either<Failure, ProductEntity>> updateProduct(String id, Map<String, dynamic> data) async {
    final updateUseCase = ref.read(updateProductUseCaseProvider);
    final previous = state;

    final result = await updateUseCase(id, data);

    result.fold(
      (failure) {},
      (updatedProduct) {
        final current = List<ProductEntity>.from(previous.value ?? const []);
        final index = current.indexWhere((p) => p.id == id);
        if (index != -1) {
          current[index] = updatedProduct;
          state = AsyncValue.data(current);
        }
      },
    );

    return result;
  }

  /// حذف منتج ومزامنة القائمة
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    final deleteUseCase = ref.read(deleteProductUseCaseProvider);
    final previous = state;

    final result = await deleteUseCase(id);

    result.fold(
      (failure) {},
      (success) {
        if (success) {
          final current = List<ProductEntity>.from(previous.value ?? const []);
          current.removeWhere((p) => p.id == id);
          state = AsyncValue.data(current);
        }
      },
    );

    return result;
  }

  /// تنظيف الخطأ
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value ?? const []);
    }
  }
}

final productsControllerProvider =
    AsyncNotifierProvider<ProductsNotifier, List<ProductEntity>>(
  ProductsNotifier.new,
);

/// موفر متحكم الواجهة والتفاعلات التفاعلي
final productsUIControllerProvider = Provider<ProductsController>((ref) {
  final getProductsUseCase = ref.watch(getProductsUseCaseProvider);
  final addProductUseCase = ref.watch(addProductUseCaseProvider);
  final updateProductUseCase = ref.watch(updateProductUseCaseProvider);
  final deleteProductUseCase = ref.watch(deleteProductUseCaseProvider);
  final uploadProductImageUseCase = ref.watch(uploadProductImageUseCaseProvider);
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  final brandRepository = ref.watch(brandRepositoryProvider);

  final controller = ProductsController(
    getProductsUseCase: getProductsUseCase,
    addProductUseCase: addProductUseCase,
    updateProductUseCase: updateProductUseCase,
    deleteProductUseCase: deleteProductUseCase,
    uploadProductImageUseCase: uploadProductImageUseCase,
    categoryRepository: categoryRepository,
    brandRepository: brandRepository,
  );

  // مزامنة تلقائية عند تحديث بيانات قائمة المنتجات
  ref.listen<AsyncValue<List<ProductEntity>>>(
    productsControllerProvider,
    (_, next) {
      next.whenData((products) {
        controller.syncWithRiverpod(products);
      });
    },
    fireImmediately: true,
  );

  ref.onDispose(controller.dispose);
  return controller;
});

// ==========================================
// Computed Selectors / Providers
// ==========================================

/// موفر قائمة المنتجات المفلترة بحسب البحث، التصنيف، والنكهة
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
        result = result.where((p) => p.flavors?.contains(selectedFlavor) ?? false);
      }

      if (query.isNotEmpty) {
        result = result.where((p) =>
            p.nameAr.toLowerCase().contains(query) ||
            p.nameEn.toLowerCase().contains(query) ||
            (p.brand?.toLowerCase().contains(query) ?? false) ||
            p.id.contains(query));
      }

      return result.toList();
    },
    orElse: () => const [],
  );
});
