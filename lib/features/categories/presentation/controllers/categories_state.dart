import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

enum CategoriesStatus { initial, loading, success, error }

/// Immutable state model for the Categories feature.
class CategoriesState {
  final CategoriesStatus status;
  final List<CategoryEntity> categories;
  final List<CategoryEntity> filteredCategories;
  final String searchQuery;
  final bool isTree;
  final bool isSubmitting;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.filteredCategories = const [],
    this.searchQuery = '',
    this.isTree = true,
    this.isSubmitting = false,
    this.errorMessage,
    this.actionSuccessMessage,
  });

  bool get isLoading => status == CategoriesStatus.loading;
  bool get hasError => status == CategoriesStatus.error && errorMessage != null;
  bool get isEmpty =>
      status == CategoriesStatus.success && filteredCategories.isEmpty;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? filteredCategories,
    String? searchQuery,
    bool? isTree,
    bool? isSubmitting,
    String? errorMessage,
    String? actionSuccessMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      searchQuery: searchQuery ?? this.searchQuery,
      isTree: isTree ?? this.isTree,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
    );
  }
}
