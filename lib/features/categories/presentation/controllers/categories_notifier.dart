import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/usecases/add_category_usecase.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/usecases/update_category_usecase.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_state.dart';

/// Riverpod Notifier managing categories state, hierarchical tree, search, and CRUD operations.
/// Strictly functional: ZERO try-catch blocks. All error handling is performed via fpdart Either.
class CategoriesNotifier extends Notifier<CategoriesState> {
  final GetCategoriesUseCase? _injectedGetCategoriesUseCase;
  final AddCategoryUseCase? _injectedAddCategoryUseCase;
  final UpdateCategoryUseCase? _injectedUpdateCategoryUseCase;
  final DeleteCategoryUseCase? _injectedDeleteCategoryUseCase;

  CategoriesNotifier({
    GetCategoriesUseCase? getCategoriesUseCase,
    AddCategoryUseCase? addCategoryUseCase,
    UpdateCategoryUseCase? updateCategoryUseCase,
    DeleteCategoryUseCase? deleteCategoryUseCase,
  })  : _injectedGetCategoriesUseCase = getCategoriesUseCase,
        _injectedAddCategoryUseCase = addCategoryUseCase,
        _injectedUpdateCategoryUseCase = updateCategoryUseCase,
        _injectedDeleteCategoryUseCase = deleteCategoryUseCase;

  GetCategoriesUseCase get _getCategoriesUseCase =>
      _injectedGetCategoriesUseCase ?? ref.read(getCategoriesUseCaseProvider);

  AddCategoryUseCase get _addCategoryUseCase =>
      _injectedAddCategoryUseCase ?? ref.read(addCategoryUseCaseProvider);

  UpdateCategoryUseCase get _updateCategoryUseCase =>
      _injectedUpdateCategoryUseCase ?? ref.read(updateCategoryUseCaseProvider);

  DeleteCategoryUseCase get _deleteCategoryUseCase =>
      _injectedDeleteCategoryUseCase ?? ref.read(deleteCategoryUseCaseProvider);

  @override
  CategoriesState build() {
    // Restores category tree automatically on initialization
    Future.microtask(() => fetchCategories(tree: true, forceRefresh: false));
    return const CategoriesState(status: CategoriesStatus.loading);
  }

  /// Fetches categories from repository. If [forceRefresh] is true, invalidates local cache.
  Future<void> fetchCategories({bool? tree, bool forceRefresh = false}) async {
    final useTree = tree ?? state.isTree;
    state = state.copyWith(
      status: CategoriesStatus.loading,
      isTree: useTree,
      errorMessage: null,
      actionSuccessMessage: null,
    );

    final result = await _getCategoriesUseCase(tree: useTree, forceRefresh: forceRefresh);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoriesStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoriesStatus.success,
          categories: categories,
          filteredCategories: _filterCategories(categories, state.searchQuery),
          errorMessage: null,
        );
      },
    );
  }

  /// Creates a new category with strict duplicate-submission guard.
  Future<bool> addCategory(CategoryEntity category) async {
    if (state.isSubmitting) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final result = await _addCategoryUseCase(category);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (newCategory) {
        final updatedList = [newCategory, ...state.categories];
        state = state.copyWith(
          isSubmitting: false,
          categories: updatedList,
          filteredCategories: _filterCategories(updatedList, state.searchQuery),
          actionSuccessMessage: 'تمت إضافة التصنيف بنجاح',
          errorMessage: null,
        );
        return true;
      },
    );
  }

  /// Updates an existing category with strict duplicate-submission guard.
  Future<bool> updateCategory(CategoryEntity category) async {
    if (state.isSubmitting) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final result = await _updateCategoryUseCase(category);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (updatedCategory) {
        final updatedList = state.categories.map((c) {
          return c.id == updatedCategory.id ? updatedCategory : c;
        }).toList();

        state = state.copyWith(
          isSubmitting: false,
          categories: updatedList,
          filteredCategories: _filterCategories(updatedList, state.searchQuery),
          actionSuccessMessage: 'تم تحديث التصنيف بنجاح',
          errorMessage: null,
        );
        return true;
      },
    );
  }

  /// Backward-compatible helper to add category from raw JSON map.
  Future<bool> addCategoryFromData(Map<String, dynamic> data) async {
    final model = CategoryModel.fromJson(data);
    return addCategory(model.toEntity());
  }

  /// Backward-compatible helper to update category from raw JSON map.
  Future<bool> updateCategoryFromData(String id, Map<String, dynamic> data) async {
    final model = CategoryModel.fromJson({...data, 'id': id});
    return updateCategory(model.toEntity());
  }

  /// Deletes a category by id with strict duplicate-submission guard.
  Future<bool> deleteCategory(String id) async {
    if (state.isSubmitting) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final result = await _deleteCategoryUseCase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        final updatedList = state.categories.where((c) => c.id != id).toList();
        state = state.copyWith(
          isSubmitting: false,
          categories: updatedList,
          filteredCategories: _filterCategories(updatedList, state.searchQuery),
          actionSuccessMessage: 'تم حذف التصنيف بنجاح',
          errorMessage: null,
        );
        return true;
      },
    );
  }

  /// Updates client-side search query and immediately applies in-memory bilingual filter.
  void updateSearchQuery(String query) {
    final trimmed = query.trim();
    state = state.copyWith(
      searchQuery: trimmed,
      filteredCategories: _filterCategories(state.categories, trimmed),
    );
  }

  /// Clears active search filter.
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      filteredCategories: state.categories,
    );
  }

  /// Toggles between hierarchical tree and flat list mode.
  void toggleTreeMode() {
    final nextMode = !state.isTree;
    fetchCategories(tree: nextMode, forceRefresh: false);
  }

  /// In-memory bilingual and ID search filtering.
  List<CategoryEntity> _filterCategories(List<CategoryEntity> list, String query) {
    if (query.isEmpty) return list;
    final lower = query.toLowerCase();

    List<CategoryEntity> filterTree(List<CategoryEntity> items) {
      final matches = <CategoryEntity>[];
      for (final cat in items) {
        final matchesSelf = cat.nameAr.toLowerCase().contains(lower) ||
            cat.nameEn.toLowerCase().contains(lower) ||
            cat.id.toLowerCase().contains(lower);

        final matchingChildren = cat.hasChildren ? filterTree(cat.children) : <CategoryEntity>[];

        if (matchesSelf || matchingChildren.isNotEmpty) {
          matches.add(cat.copyWith(
            children: matchingChildren.isNotEmpty ? matchingChildren : cat.children,
          ));
        }
      }
      return matches;
    }

    return filterTree(list);
  }
}
