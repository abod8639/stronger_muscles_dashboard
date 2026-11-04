import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// Mixin managing product catalog data lists, search queries, and filtering logic.
/// Complies with SRP by isolating catalog searching and filtering behavior.
mixin ProductFilterMixin on ChangeNotifier {
  CategoryRepository get categoryRepository;
  BrandRepository get brandRepository;
  Map<String, TextEditingController> get textcontrollers;

  // --- Loading States ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    if (_isLoading != v) {
      _isLoading = v;
      notifyListeners();
    }
  }

  bool _isCreatingBrand = false;
  bool get isCreatingBrand => _isCreatingBrand;

  // --- Data Lists ---
  final List<ProductEntity> products = [];
  final List<CategoryEntity> categories = [];
  final List<BrandEntity> brands = [];
  final List<ProductEntity> filteredProducts = [];

  // --- Filter Values ---
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategoryId = 'all';
  String get selectedCategoryId => _selectedCategoryId;

  String _selectedFlavorId = 'all';
  String get selectedFlavorId => _selectedFlavorId;

  /// Fetches initial category and brand lists from repositories
  Future<void> fetchData({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();

    final catResult = await categoryRepository.getCategories(
      tree: true,
      forceRefresh: forceRefresh,
    );
    catResult.fold(
      (failure) => debugPrint('Error categories: ${failure.toMessage()}'),
      (cats) {
        categories
          ..clear()
          ..addAll(cats);
      },
    );

    final brandsResult = await brandRepository.getBrands(
      forceRefresh: forceRefresh,
    );
    brandsResult.fold(
      (failure) => debugPrint('Error brands: ${failure.toMessage()}'),
      (bList) {
        brands
          ..clear()
          ..addAll(bList);
      },
    );

    applyFiltering();
    _isLoading = false;
    notifyListeners();
  }

  /// Synchronizes products list from Riverpod state
  void syncWithRiverpod(List<ProductEntity> newProducts) {
    products
      ..clear()
      ..addAll(newProducts);
    applyFiltering();
    _isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    applyFiltering();
    notifyListeners();
  }

  void setCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    applyFiltering();
    notifyListeners();
  }

  void setFlavor(String flavorId) {
    _selectedFlavorId = flavorId;
    applyFiltering();
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryId = 'all';
    _selectedFlavorId = 'all';
    applyFiltering();
    notifyListeners();
  }

  /// Applies active search and filter constraints to the products list
  void applyFiltering() {
    final query = _searchQuery.toLowerCase().trim();

    filteredProducts
      ..clear()
      ..addAll(
        products.where((product) {
          final matchesCategory =
              _selectedCategoryId == 'all' ||
              product.categoryId == _selectedCategoryId;

          final matchesFlavor =
              _selectedFlavorId == 'all' ||
              (product.flavors != null &&
                  product.flavors!.any((f) {
                    final clean =
                        f.contains('|') ? f.split('|').first.trim() : f.trim();
                    return clean.toLowerCase() ==
                        _selectedFlavorId.toLowerCase();
                  }));

          final matchesSearch =
              query.isEmpty ||
              product.nameAr.toLowerCase().contains(query) ||
              product.nameEn.toLowerCase().contains(query) ||
              (product.brand != null &&
                  product.brand!.toLowerCase().contains(query)) ||
              product.id.contains(query);

          return matchesCategory && matchesFlavor && matchesSearch;
        }),
      );
  }

  /// Creates and stores a new brand directly in the database
  Future<BrandEntity?> quickAddBrand(String brandName) async {
    final trimmed = brandName.trim();
    if (trimmed.isEmpty) return null;

    // Check if already registered in current list
    for (final b in brands) {
      if (b.nameAr.trim().toLowerCase() == trimmed.toLowerCase() ||
          b.nameEn.trim().toLowerCase() == trimmed.toLowerCase() ||
          b.displayName.trim().toLowerCase() == trimmed.toLowerCase()) {
        textcontrollers['brand']?.text = b.displayName;
        AppFeedback.showInfo('العلامة التجارية مسجلة بالفعل');
        return b;
      }
    }

    _isCreatingBrand = true;
    notifyListeners();

    final result = await brandRepository.createBrand({
      'name': {
        'ar': trimmed,
        'en': trimmed,
      },
      'is_active': true,
    });

    BrandEntity? createdBrand;
    result.fold(
      (failure) {
        AppFeedback.showError(
          'تعذر إضافة العلامة التجارية: ${failure.toMessage()}',
        );
      },
      (newBrand) {
        brands.insert(0, newBrand);
        textcontrollers['brand']?.text = newBrand.displayName;
        AppFeedback.showSuccess('تمت إضافة العلامة التجارية وتخزينها بنجاح');
        createdBrand = newBrand;
      },
    );

    _isCreatingBrand = false;
    notifyListeners();
    return createdBrand;
  }
}
