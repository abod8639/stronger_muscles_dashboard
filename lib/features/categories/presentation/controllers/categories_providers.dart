import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/category_local_datasource.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import 'categories_controller.dart';
import 'categories_notifier.dart';
import 'categories_state.dart';

// Re-export centralized dioProvider for any legacy consumers
export 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';

/// ============================================================================
/// DATA LAYER PROVIDERS (Scoped & Lazily Evaluated)
/// ============================================================================

/// Provider for the categories Hive Box
final categoriesHiveBoxProvider = Provider<Box<CategoryModel>>((ref) {
  return Hive.box<CategoryModel>('categories');
});

/// Provider for [CategoryLocalDataSource] backed by Hive
final categoryLocalDataSourceProvider = Provider<CategoryLocalDataSource>((
  ref,
) {
  final box = ref.watch(categoriesHiveBoxProvider);
  return CategoryLocalDataSourceImpl(box: box);
});

/// Provider for [CategoryRemoteDataSource] backed by centralized [dioProvider]
final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CategoryRemoteDataSourceImpl(dio: dio);
});

/// Provider for [CategoryRepository] as the Single Source of Truth
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remote = ref.watch(categoryRemoteDataSourceProvider);
  final local = ref.watch(categoryLocalDataSourceProvider);
  return CategoryRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

/// ============================================================================
/// DOMAIN LAYER PROVIDERS (UseCases)
/// ============================================================================

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final getCategoryByIdUseCaseProvider = Provider<GetCategoryByIdUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoryByIdUseCase(repository);
});

final addCategoryUseCaseProvider = Provider<AddCategoryUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return AddCategoryUseCase(repository);
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return UpdateCategoryUseCase(repository);
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return DeleteCategoryUseCase(repository);
});

/// ============================================================================
/// PRESENTATION LAYER PROVIDERS (StateNotifier & Selectors)
/// ============================================================================

/// Primary Notifier provider managing immutable [CategoriesState]
final categoriesNotifierProvider =
    NotifierProvider<CategoriesNotifier, CategoriesState>(
      CategoriesNotifier.new,
    );

/// Backward-compatible selector for filtered categories list
final filteredCategoriesProvider = Provider<List<CategoryEntity>>((ref) {
  return ref.watch(
    categoriesNotifierProvider.select((s) => s.filteredCategories),
  );
});

/// Backward-compatible selector for search query string
final categoriesSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(categoriesNotifierProvider.select((s) => s.searchQuery));
});

/// Backward-compatible provider for CategoryFormController
final categoryFormControllerProvider = Provider.autoDispose
    .family<CategoriesController, CategoryEntity?>((ref, category) {
      final controller = CategoriesController();
      final allCategories = ref.watch(
        categoriesNotifierProvider.select((s) => s.categories),
      );
      controller.categories = allCategories;
      if (category != null) {
        controller.prepareFormForEdit(category);
      } else {
        controller.clearForm();
      }
      ref.onDispose(controller.dispose);
      return controller;
    });
