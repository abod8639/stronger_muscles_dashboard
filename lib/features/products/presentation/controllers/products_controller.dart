import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';

/// Pure Controller managing product UI actions, form validations, and bulk operations.
/// 100% free of raw try-catch blocks in adherence to Clean Architecture.
class ProductsController extends ChangeNotifier {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadProductImageUseCase _uploadProductImageUseCase;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;

  ProductsController({
    GetProductsUseCase? getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UploadProductImageUseCase uploadProductImageUseCase,
    required CategoryRepository categoryRepository,
    required BrandRepository brandRepository,
  }) : _addProductUseCase = addProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       _uploadProductImageUseCase = uploadProductImageUseCase,
       _categoryRepository = categoryRepository,
       _brandRepository = brandRepository {
    fetchData();
  }

  // --- States ---
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool v) {
    if (_isLoading != v) {
      _isLoading = v;
      notifyListeners();
    }
  }

  bool _isUploadingImage = false;
  bool get isUploadingImage => _isUploadingImage;
  set isUploadingImage(bool v) {
    if (_isUploadingImage != v) {
      _isUploadingImage = v;
      notifyListeners();
    }
  }

  bool _isSaving = false;
  bool get isSaving => _isSaving;
  set isSaving(bool v) {
    if (_isSaving != v) {
      _isSaving = v;
      notifyListeners();
    }
  }

  // --- Data Lists ---
  final List<ProductEntity> products = [];
  final List<CategoryEntity> categories = [];
  final List<BrandEntity> brands = [];
  final List<ProductEntity> filteredProducts = [];

  // --- Selection & Bulk Actions State ---
  bool _isSelectionMode = false;
  bool get isSelectionMode => _isSelectionMode;
  set isSelectionMode(bool v) {
    if (_isSelectionMode != v) {
      _isSelectionMode = v;
      notifyListeners();
    }
  }

  final Set<String> selectedProductIds = {};

  bool _isBulkOperating = false;
  bool get isBulkOperating => _isBulkOperating;
  set isBulkOperating(bool v) {
    if (_isBulkOperating != v) {
      _isBulkOperating = v;
      notifyListeners();
    }
  }

  bool get isAllSelected =>
      filteredProducts.isNotEmpty &&
      selectedProductIds.length >= filteredProducts.length &&
      filteredProducts.every((p) => selectedProductIds.contains(p.id));

  int get selectedCount => selectedProductIds.length;

  // Form specific state
  final List<ProductSizeEntity> productSizes = [];
  final List<String> productFlavors = [];
  final List<String> imageUrls = [];

  void addImageUrl(String url) {
    imageUrls.add(url);
    notifyListeners();
  }

  void removeImageUrl(int index) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls.removeAt(index);
      notifyListeners();
    }
  }

  void reorderImageUrl(int oldIndex, int newIndex) {
    if (oldIndex >= 0 && oldIndex < imageUrls.length) {
      final item = imageUrls.removeAt(oldIndex);
      imageUrls.insert(newIndex, item);
      notifyListeners();
    }
  }

  void updateProductFlavors(List<String> newFlavors) {
    productFlavors
      ..clear()
      ..addAll(newFlavors);
    notifyListeners();
  }

  bool _isFeatured = false;
  bool get isFeatured => _isFeatured;
  set isFeatured(bool v) {
    if (_isFeatured != v) {
      _isFeatured = v;
      notifyListeners();
    }
  }

  bool _isActive = true;
  bool get isActive => _isActive;
  set isActive(bool v) {
    if (_isActive != v) {
      _isActive = v;
      notifyListeners();
    }
  }

  bool _isBackgroundWhite = false;
  bool get isBackgroundWhite => _isBackgroundWhite;
  set isBackgroundWhite(bool v) {
    if (_isBackgroundWhite != v) {
      _isBackgroundWhite = v;
      notifyListeners();
    }
  }

  int _selectedSizeIndex = -1;
  int get selectedSizeIndex => _selectedSizeIndex;
  set selectedSizeIndex(int v) {
    if (_selectedSizeIndex != v) {
      _selectedSizeIndex = v;
      notifyListeners();
    }
  }

  final List<ProductVariantEntity> variants = [];
  final List<String> tags = [];
  final List<String> allergens = [];

  bool _newArrival = false;
  bool get newArrival => _newArrival;
  set newArrival(bool v) {
    if (_newArrival != v) {
      _newArrival = v;
      notifyListeners();
    }
  }

  bool _bestSeller = false;
  bool get bestSeller => _bestSeller;
  set bestSeller(bool v) {
    if (_bestSeller != v) {
      _bestSeller = v;
      notifyListeners();
    }
  }

  void addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !tags.contains(trimmed)) {
      tags.add(trimmed);
      notifyListeners();
    }
  }

  void removeTag(int index) {
    if (index >= 0 && index < tags.length) {
      tags.removeAt(index);
      notifyListeners();
    }
  }

  void toggleAllergen(String allergen) {
    if (allergens.contains(allergen)) {
      allergens.remove(allergen);
    } else {
      allergens.add(allergen);
    }
    notifyListeners();
  }

  // --- Filter Values ---
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategoryId = 'all';
  String get selectedCategoryId => _selectedCategoryId;

  String _selectedFlavorId = 'all';
  String get selectedFlavorId => _selectedFlavorId;

  final Map<String, TextEditingController> textcontrollers = {
    'name_ar': TextEditingController(),
    'name_en': TextEditingController(),
    'price': TextEditingController(),
    'discount': TextEditingController(),
    'desc_ar': TextEditingController(),
    'desc_en': TextEditingController(),
    'stock': TextEditingController(),
    'brand': TextEditingController(),
    'serving': TextEditingController(),
    'sessions': TextEditingController(),
    'sku': TextEditingController(),
    'calories': TextEditingController(),
    'protein': TextEditingController(),
    'carbs': TextEditingController(),
    'fat': TextEditingController(),
    'sugar': TextEditingController(),
  };

  // Controllers for each size
  final Map<String, TextEditingController> sizePriceControllers = {};
  final Map<String, TextEditingController> sizeDiscountControllers = {};
  final Map<String, TextEditingController> sizeServingsControllers = {};
  final Map<String, TextEditingController> sizeWeightControllers = {};
  final Map<String, TextEditingController> sizeStockControllers = {};

  int get totalSizesStock {
    int sum = 0;
    for (var ps in productSizes) {
      final text = sizeStockControllers[ps.size]?.text.trim() ?? '';
      sum += int.tryParse(text) ?? 0;
    }
    return sum;
  }

  int get totalVariantsStock {
    int sum = 0;
    for (var v in variants) {
      sum += v.stockQuantity;
    }
    return sum;
  }

  void notifySizeStockChanged() {
    notifyListeners();
  }

  Future<void> fetchData({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();

    final catResult = await _categoryRepository.getCategories(
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

    final brandsResult = await _brandRepository.getBrands(
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

    _applyFiltering();
    _isLoading = false;
    notifyListeners();
  }

  bool _isCreatingBrand = false;
  bool get isCreatingBrand => _isCreatingBrand;

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

    final result = await _brandRepository.createBrand({
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

  /// Synchronizes products list from Riverpod state
  void syncWithRiverpod(List<ProductEntity> newProducts) {
    products
      ..clear()
      ..addAll(newProducts);
    _applyFiltering();
    _isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFiltering();
    notifyListeners();
  }

  void setCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _applyFiltering();
    notifyListeners();
  }

  void setFlavor(String flavorId) {
    _selectedFlavorId = flavorId;
    _applyFiltering();
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategoryId = 'all';
    _selectedFlavorId = 'all';
    _applyFiltering();
    notifyListeners();
  }

  void _applyFiltering() {
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

  void initForForm({ProductEntity? product}) {
    imageUrls.clear();
    productSizes.clear();
    productFlavors.clear();
    variants.clear();
    tags.clear();
    allergens.clear();
    selectedProductIds.clear();
    clearSizeControllers();

    if (product != null) {
      textcontrollers['name_ar']?.text = product.nameAr;
      textcontrollers['name_en']?.text = product.nameEn;
      textcontrollers['price']?.text = product.price.toString();
      textcontrollers['discount']?.text =
          product.discountPrice?.toString() ?? '';
      textcontrollers['desc_ar']?.text = product.descriptionAr;
      textcontrollers['desc_en']?.text = product.descriptionEn;
      textcontrollers['stock']?.text = product.stockQuantity.toString();
      textcontrollers['brand']?.text = product.brand ?? '';
      textcontrollers['serving']?.text = product.servingSize ?? '';
      textcontrollers['sessions']?.text =
          product.servingsPerContainer?.toString() ?? '';
      textcontrollers['sku']?.text = product.sku ?? '';

      // Populate nutrition facts
      final facts = product.nutritionFacts;
      if (facts != null) {
        textcontrollers['calories']?.text = facts['calories']?.toString() ?? '';
        textcontrollers['protein']?.text = facts['protein']?.toString() ?? '';
        textcontrollers['carbs']?.text = facts['carbs']?.toString() ?? '';
        textcontrollers['fat']?.text = facts['fat']?.toString() ?? '';
        textcontrollers['sugar']?.text = facts['sugar']?.toString() ?? '';
        if (facts['allergens'] is List) {
          allergens.addAll((facts['allergens'] as List).map((e) => e.toString()));
        }
      } else {
        textcontrollers['calories']?.clear();
        textcontrollers['protein']?.clear();
        textcontrollers['carbs']?.clear();
        textcontrollers['fat']?.clear();
        textcontrollers['sugar']?.clear();
      }

      if (product.tags != null) {
        tags.addAll(product.tags!);
      }

      _isFeatured = product.isFeatured;
      _isActive = product.isActive;
      _isBackgroundWhite = product.isBackgroundWhite ?? false;
      _newArrival = product.newArrival;
      _bestSeller = product.bestSeller;

      imageUrls.addAll(product.imageUrls);

      if (product.productSizes != null) {
        for (var ps in product.productSizes!) {
          productSizes.add(ps);
          sizePriceControllers[ps.size] = TextEditingController(
            text: ps.price.toString(),
          );
          sizeDiscountControllers[ps.size] = TextEditingController(
            text: ps.discountPrice?.toString() ?? '',
          );
          sizeServingsControllers[ps.size] = TextEditingController(
            text: ps.servings?.toString() ?? '',
          );
          sizeWeightControllers[ps.size] = TextEditingController(
            text: ps.weight ?? '',
          );
          sizeStockControllers[ps.size] = TextEditingController(
            text: ps.stockQuantity?.toString() ?? '',
          );
        }
      }

      if (product.flavors != null) {
        productFlavors.addAll(product.flavors!);
      }

      if (product.variants != null) {
        variants.addAll(product.variants!);
      }
    } else {
      for (var c in textcontrollers.values) {
        c.clear();
      }
      _isFeatured = false;
      _isActive = true;
      _isBackgroundWhite = false;
      _newArrival = false;
      _bestSeller = false;
    }
    notifyListeners();
  }

  /// تنظيف وتفريغ كافة متحكمات النموذج والذاكرة بالكامل لمنع تسريب الموارد
  void clearForm() {
    clearSizeControllers();
    for (var c in textcontrollers.values) {
      c.clear();
    }
    imageUrls.clear();
    productSizes.clear();
    productFlavors.clear();
    variants.clear();
    tags.clear();
    allergens.clear();
    _isFeatured = false;
    _isActive = true;
    _isBackgroundWhite = false;
    _newArrival = false;
    _bestSeller = false;
    _selectedSizeIndex = -1;
    notifyListeners();
  }

  void addProductSize(
    String size,
    double price,
    double? discount, {
    int? servings,
    String? weight,
    int? stockQuantity,
    List<String>? flavors,
  }) {
    final newSize = ProductSizeEntity(
      size: size,
      price: price,
      discountPrice: discount,
      servings: servings,
      weight: weight,
      stockQuantity: stockQuantity,
      flavors: flavors ?? (productFlavors.isNotEmpty ? List<String>.from(productFlavors) : null),
    );
    productSizes.add(newSize);
    sizePriceControllers[size] = TextEditingController(text: price.toString());
    sizeDiscountControllers[size] = TextEditingController(
      text: discount?.toString() ?? '',
    );
    sizeServingsControllers[size] = TextEditingController(
      text: servings?.toString() ?? '',
    );
    sizeWeightControllers[size] = TextEditingController(
      text: weight ?? '',
    );
    sizeStockControllers[size] = TextEditingController(
      text: stockQuantity?.toString() ?? '',
    );
    notifyListeners();
  }

  void removeProductSize(int index) {
    if (index >= 0 && index < productSizes.length) {
      final size = productSizes[index].size;
      sizePriceControllers[size]?.dispose();
      sizePriceControllers.remove(size);
      sizeDiscountControllers[size]?.dispose();
      sizeDiscountControllers.remove(size);
      sizeServingsControllers[size]?.dispose();
      sizeServingsControllers.remove(size);
      sizeWeightControllers[size]?.dispose();
      sizeWeightControllers.remove(size);
      sizeStockControllers[size]?.dispose();
      sizeStockControllers.remove(size);
      productSizes.removeAt(index);
      notifyListeners();
    }
  }

  void selectSize(int index) {
    selectedSizeIndex = index;
    notifyListeners();
  }

  void updateSizeFlavors(String sizeName, List<String> flavors) {
    final index = productSizes.indexWhere((s) => s.size == sizeName);
    if (index != -1) {
      productSizes[index] = productSizes[index].copyWith(flavors: flavors);
      for (final f in flavors) {
        if (!productFlavors.contains(f)) {
          productFlavors.add(f);
        }
      }
      notifyListeners();
    }
  }

  void applyFlavorsToAllSizes(List<String> flavors) {
    for (int i = 0; i < productSizes.length; i++) {
      productSizes[i] = productSizes[i].copyWith(
        flavors: List<String>.from(flavors),
      );
    }
    for (final f in flavors) {
      if (!productFlavors.contains(f)) {
        productFlavors.add(f);
      }
    }
    notifyListeners();
  }

  List<String> getFlavorsForSize(String sizeName) {
    final match = productSizes.where((s) => s.size == sizeName);
    if (match.isNotEmpty &&
        match.first.flavors != null &&
        match.first.flavors!.isNotEmpty) {
      return match.first.flavors!;
    }
    return productFlavors;
  }

  void syncSizeControllers() {
    for (var ps in productSizes) {
      sizePriceControllers.putIfAbsent(
        ps.size,
        () => TextEditingController(text: ps.price.toString()),
      );
      sizeDiscountControllers.putIfAbsent(
        ps.size,
        () => TextEditingController(text: ps.discountPrice?.toString() ?? ''),
      );
      sizeServingsControllers.putIfAbsent(
        ps.size,
        () => TextEditingController(text: ps.servings?.toString() ?? ''),
      );
      sizeWeightControllers.putIfAbsent(
        ps.size,
        () => TextEditingController(text: ps.weight ?? ''),
      );
      sizeStockControllers.putIfAbsent(
        ps.size,
        () => TextEditingController(text: ps.stockQuantity?.toString() ?? ''),
      );
    }
    notifyListeners();
  }

  void clearSizeControllers() {
    for (var c in sizePriceControllers.values) {
      c.dispose();
    }
    sizePriceControllers.clear();
    for (var c in sizeDiscountControllers.values) {
      c.dispose();
    }
    sizeDiscountControllers.clear();
    for (var c in sizeServingsControllers.values) {
      c.dispose();
    }
    sizeServingsControllers.clear();
    for (var c in sizeWeightControllers.values) {
      c.dispose();
    }
    sizeWeightControllers.clear();
    for (var c in sizeStockControllers.values) {
      c.dispose();
    }
    sizeStockControllers.clear();
  }

  void addNewVariant() {
    final newVariant = ProductVariantEntity(
      id: 'VAR-${DateTime.now().millisecondsSinceEpoch}',
      sku: 'SKU-${DateTime.now().millisecondsSinceEpoch % 10000}',
      price: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      discountPrice: double.tryParse(textcontrollers['discount']?.text ?? ''),
      effectivePrice:
          double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      stockQuantity: int.tryParse(textcontrollers['stock']?.text ?? '0') ?? 0,
      attributes: const {},
      isActive: true,
    );
    variants.add(newVariant);
    notifyListeners();
  }

  /// يولد مصفوفة التنويعات (SKU Matrix) تلقائياً من تقاطع الأحجام والنكهات
  void generateVariantsMatrix() {
    if (productSizes.isEmpty && productFlavors.isEmpty) {
      AppFeedback.showWarning(
        'يرجى تحديد الأحجام أو النكهات أولاً لتوليد مصفوفة التنويعات',
      );
      return;
    }

    variants.clear();
    final baseSku = textcontrollers['sku']?.text.trim().isNotEmpty == true
        ? textcontrollers['sku']!.text.trim()
        : 'PROD-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final basePrice =
        double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0;
    final baseDiscount = double.tryParse(
      textcontrollers['discount']?.text ?? '',
    );

    // الحالة 1: وجود أحجام ونكهات معاً
    if (productSizes.isNotEmpty && productFlavors.isNotEmpty) {
      for (final sizeEntity in productSizes) {
        final sizePrice =
            double.tryParse(
              sizePriceControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.price;
        final sizeDiscount =
            double.tryParse(
              sizeDiscountControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.discountPrice;
        final sizeStock =
            int.tryParse(
              sizeStockControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.stockQuantity ??
            0;

        final sizeFlavors =
            (sizeEntity.flavors != null && sizeEntity.flavors!.isNotEmpty)
            ? sizeEntity.flavors!
            : productFlavors;

        final perFlavorStock = sizeFlavors.isNotEmpty
            ? (sizeStock / sizeFlavors.length).floor()
            : sizeStock;

        for (final flavor in sizeFlavors) {
          final cleanFlavor = flavor.contains('|')
              ? flavor.split('|').first.trim()
              : flavor;
          final cleanSize = sizeEntity.size;
          final sku = '$baseSku-$cleanSize-$cleanFlavor'
              .replaceAll(' ', '-')
              .toUpperCase();
          final effectivePrice = (sizeDiscount != null && sizeDiscount > 0)
              ? sizeDiscount
              : (sizePrice > 0 ? sizePrice : basePrice);

          variants.add(
            ProductVariantEntity(
              id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
              sku: sku,
              price: sizePrice > 0 ? sizePrice : basePrice,
              discountPrice: sizeDiscount ?? baseDiscount,
              effectivePrice: effectivePrice,
              stockQuantity: perFlavorStock,
              attributes: {
                'size': cleanSize,
                'flavor': cleanFlavor,
              },
              isActive: true,
            ),
          );
        }
      }
    } else if (productSizes.isNotEmpty) {
      // الحالة 2: وجود أحجام فقط
      for (final sizeEntity in productSizes) {
        final sizePrice =
            double.tryParse(
              sizePriceControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.price;
        final sizeDiscount =
            double.tryParse(
              sizeDiscountControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.discountPrice;
        final sizeStock =
            int.tryParse(
              sizeStockControllers[sizeEntity.size]?.text ?? '',
            ) ??
            sizeEntity.stockQuantity ??
            0;
        final cleanSize = sizeEntity.size;
        final sku = '$baseSku-$cleanSize'.replaceAll(' ', '-').toUpperCase();
        final effectivePrice = (sizeDiscount != null && sizeDiscount > 0)
            ? sizeDiscount
            : (sizePrice > 0 ? sizePrice : basePrice);

        variants.add(
          ProductVariantEntity(
            id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
            sku: sku,
            price: sizePrice > 0 ? sizePrice : basePrice,
            discountPrice: sizeDiscount ?? baseDiscount,
            effectivePrice: effectivePrice,
            stockQuantity: sizeStock,
            attributes: {'size': cleanSize},
            isActive: true,
          ),
        );
      }
    } else {
      // الحالة 3: وجود نكهات فقط
      for (final flavor in productFlavors) {
        final cleanFlavor = flavor.contains('|')
            ? flavor.split('|').first.trim()
            : flavor;
        final sku = '$baseSku-$cleanFlavor'.replaceAll(' ', '-').toUpperCase();
        final effectivePrice = (baseDiscount != null && baseDiscount > 0)
            ? baseDiscount
            : basePrice;

        variants.add(
          ProductVariantEntity(
            id: 'VAR-${DateTime.now().millisecondsSinceEpoch}-${variants.length}',
            sku: sku,
            price: basePrice,
            discountPrice: baseDiscount,
            effectivePrice: effectivePrice,
            stockQuantity: 0,
            attributes: {'flavor': cleanFlavor},
            isActive: true,
          ),
        );
      }
    }

    notifyListeners();
    AppFeedback.showSuccess(
      'تم توليد ${variants.length} تنويع (SKU) تلقائياً بنجاح',
    );
  }

  void addVariant(ProductVariantEntity variant) {
    variants.add(variant);
    notifyListeners();
  }

  void removeVariant(int index) {
    if (index >= 0 && index < variants.length) {
      variants.removeAt(index);
      notifyListeners();
    }
  }

  void updateVariant(int index, ProductVariantEntity updated) {
    if (index >= 0 && index < variants.length) {
      variants[index] = updated;
      notifyListeners();
    }
  }

  /// تطبيق تعديل جماعي على كافة التنويعات (سعر، خصم، ومخزون موحد)
  void bulkUpdateVariants({
    double? price,
    double? discountPrice,
    int? stockQuantity,
  }) {
    if (variants.isEmpty) return;
    for (int i = 0; i < variants.length; i++) {
      final v = variants[i];
      final newPrice = price ?? v.price;
      final newDiscount = discountPrice ?? v.discountPrice;
      final newStock = stockQuantity ?? v.stockQuantity;
      final effective = (newDiscount != null && newDiscount > 0)
          ? newDiscount
          : newPrice;

      variants[i] = v.copyWith(
        price: newPrice,
        discountPrice: newDiscount,
        effectivePrice: effective,
        stockQuantity: newStock,
      );
    }
    notifyListeners();
    AppFeedback.showSuccess('تم تطبيق التعديلات على كافة التنويعات بنجاح');
  }

  Future<bool> saveProduct({
    required GlobalKey<FormState> formKey,
    required String categoryId,
    required List<String> productImages,
    ProductEntity? existingProduct,
  }) async {
    if (_isSaving) return false;
    if (!formKey.currentState!.validate()) return false;
    if (productImages.isEmpty) {
      AppFeedback.showWarning('يجب إضافة صورة واحدة على الأقل');
      return false;
    }
    if (categoryId.isEmpty || categoryId == 'all') {
      AppFeedback.showWarning('يرجى اختيار القسم');
      return false;
    }

    _isSaving = true;
    notifyListeners();

    final updatedSizes = productSizes.map((ps) {
      final price =
          double.tryParse(sizePriceControllers[ps.size]?.text ?? '0') ?? 0.0;
      final discount = double.tryParse(
        sizeDiscountControllers[ps.size]?.text ?? '',
      );
      final servings =
          int.tryParse(sizeServingsControllers[ps.size]?.text.trim() ?? '');
      final weight = sizeWeightControllers[ps.size]?.text.trim();
      final stock =
          int.tryParse(sizeStockControllers[ps.size]?.text.trim() ?? '');
      return ProductSizeEntity(
        size: ps.size,
        price: price,
        discountPrice: discount,
        servings: servings,
        weight: (weight != null && weight.isNotEmpty) ? weight : null,
        stockQuantity: stock,
        flavors: ps.flavors,
      );
    }).toList();

    int totalStock = int.tryParse(textcontrollers['stock']!.text.trim()) ?? 0;
    if (variants.isNotEmpty) {
      final sumVariantsStock = variants.fold<int>(
        0,
        (sum, v) => sum + v.stockQuantity,
      );
      if (sumVariantsStock > 0 || totalStock == 0) {
        totalStock = sumVariantsStock;
      }
    } else if (totalStock == 0 && updatedSizes.isNotEmpty) {
      int sumSizesStock = 0;
      for (final s in updatedSizes) {
        if (s.stockQuantity != null) {
          sumSizesStock += s.stockQuantity!;
        }
      }
      if (sumSizesStock > 0) {
        totalStock = sumSizesStock;
      }
    }

    double mainPrice = double.tryParse(textcontrollers['price']!.text) ?? 0.0;
    double? discountPrice = double.tryParse(textcontrollers['discount']!.text);

    if (mainPrice == 0 && updatedSizes.isNotEmpty) {
      mainPrice = updatedSizes.first.price;
      discountPrice = updatedSizes.first.discountPrice;
    }

    final String generatedId =
        existingProduct?.id ?? 'PROD-${DateTime.now().millisecondsSinceEpoch}';

    final enteredBrand = textcontrollers['brand']!.text.trim();
    BrandEntity? matchedBrand;
    for (final b in brands) {
      if (b.nameAr.trim().toLowerCase() == enteredBrand.toLowerCase() ||
          b.nameEn.trim().toLowerCase() == enteredBrand.toLowerCase() ||
          b.displayName.trim().toLowerCase() == enteredBrand.toLowerCase()) {
        matchedBrand = b;
        break;
      }
    }

    // Auto-create brand in database if it doesn't already exist
    if (enteredBrand.isNotEmpty && matchedBrand == null) {
      final createResult = await _brandRepository.createBrand({
        'name': {
          'ar': enteredBrand,
          'en': enteredBrand,
        },
        'is_active': true,
      });
      createResult.fold(
        (failure) {
          debugPrint('⚠️ Auto-create brand failed: ${failure.toMessage()}');
        },
        (newBrand) {
          matchedBrand = newBrand;
          brands.insert(0, newBrand);
          notifyListeners();
        },
      );
    }

    final nameAr = textcontrollers['name_ar']!.text.trim();
    final nameEn = textcontrollers['name_en']!.text.trim();
    final finalNameEn = nameEn.isNotEmpty ? nameEn : nameAr;

    final descAr = textcontrollers['desc_ar']!.text.trim();
    final descEn = textcontrollers['desc_en']!.text.trim();
    final finalDescEn = descEn.isNotEmpty ? descEn : descAr;

    final nutritionFacts = <String, dynamic>{
      if (textcontrollers['calories']!.text.trim().isNotEmpty)
        'calories': textcontrollers['calories']!.text.trim(),
      if (textcontrollers['protein']!.text.trim().isNotEmpty)
        'protein': textcontrollers['protein']!.text.trim(),
      if (textcontrollers['carbs']!.text.trim().isNotEmpty)
        'carbs': textcontrollers['carbs']!.text.trim(),
      if (textcontrollers['fat']!.text.trim().isNotEmpty)
        'fat': textcontrollers['fat']!.text.trim(),
      if (textcontrollers['sugar']!.text.trim().isNotEmpty)
        'sugar': textcontrollers['sugar']!.text.trim(),
      if (allergens.isNotEmpty) 'allergens': allergens.toList(),
    };

    final productData = {
      'id': generatedId,
      'name': {
        'ar': nameAr,
        'en': finalNameEn,
      },
      'description': {
        'ar': descAr,
        'en': finalDescEn,
      },
      'price': mainPrice,
      'discount_price': discountPrice,
      'image_urls': productImages,
      'category_id': categoryId,
      'stock_quantity': totalStock,
      'brand': enteredBrand,
      if (matchedBrand != null) 'brand_id': matchedBrand!.id,
      'sku': textcontrollers['sku']!.text.trim().isNotEmpty
          ? textcontrollers['sku']!.text.trim()
          : null,
      'tags': tags.toList(),
      'nutrition_facts': nutritionFacts.isNotEmpty ? nutritionFacts : null,
      'is_active': _isActive,
      'featured': _isFeatured,
      'new_arrival': _newArrival,
      'best_seller': _bestSeller,
      'is_background_white': _isBackgroundWhite,
      'serving_size': textcontrollers['serving']!.text.trim().isNotEmpty
          ? textcontrollers['serving']!.text.trim()
          : (updatedSizes.isNotEmpty &&
                  (updatedSizes.first.weight?.isNotEmpty ?? false)
              ? updatedSizes.first.weight!
              : ''),
      'servings_per_container':
          (int.tryParse(textcontrollers['sessions']!.text.trim()) ?? 0) > 0
              ? int.tryParse(textcontrollers['sessions']!.text.trim())!
              : (updatedSizes.isNotEmpty &&
                      updatedSizes.first.servings != null
                  ? updatedSizes.first.servings!
                  : 0),
      'flavors': productFlavors.toList(),
      'product_sizes': updatedSizes
          .map(
            (s) => {
              'size': s.size,
              'price': s.price,
              'discount_price': s.discountPrice,
              if (s.servings != null) 'servings': s.servings,
              if (s.servings != null) 'servings_per_container': s.servings,
              if (s.weight != null) 'weight': s.weight,
              if (s.weight != null) 'serving_size': s.weight,
              if (s.stockQuantity != null) 'stock_quantity': s.stockQuantity,
              if (s.stockQuantity != null) 'stock': s.stockQuantity,
              if (s.flavors != null) 'flavors': s.flavors,
            },
          )
          .toList(),
      'product_variants': variants
          .map(
            (v) => {
              'id': v.id,
              'sku': v.sku,
              'price': v.price,
              'discount_price': v.discountPrice,
              'effective_price': v.effectivePrice,
              'stock_quantity': v.stockQuantity,
              'attributes': v.attributes,
              'is_active': v.isActive,
            },
          )
          .toList(),
    };

    bool isSuccess = false;
    if (existingProduct == null) {
      final result = await _addProductUseCase(productData);
      isSuccess = result.fold<bool>(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (newProduct) {
          products.insert(0, newProduct);
          AppFeedback.showSuccess('تم إضافة المنتج بنجاح');
          _applyFiltering();
          notifyListeners();
          return true;
        },
      );
    } else {
      final result = await _updateProductUseCase(
        existingProduct.id,
        productData,
      );
      isSuccess = result.fold<bool>(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (updatedProduct) {
          final index = products.indexWhere((p) => p.id == existingProduct.id);
          if (index != -1) products[index] = updatedProduct;
          AppFeedback.showSuccess('تم تحديث المنتج بنجاح');
          _applyFiltering();
          notifyListeners();
          return true;
        },
      );
    }

    _isSaving = false;
    notifyListeners();
    return isSuccess;
  }

  void confirmDelete(BuildContext context, String id, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تأكيد الحذف',
        message: 'هل أنت متأكد أنك تريد حذف المنتج "$productName"؟',
        confirmText: 'حذف',
        confirmColor: Colors.red,
        icon: Icons.delete_forever_rounded,
        onConfirm: () {
          Navigator.of(ctx).pop();
          _executeDelete(id);
        },
      ),
    );
  }

  Future<void> _executeDelete(String id) async {
    final result = await _deleteProductUseCase(id);
    result.fold((failure) => AppFeedback.showError(failure.toMessage()), (
      success,
    ) {
      if (success) {
        products.removeWhere((p) => p.id == id);
        _applyFiltering();
        notifyListeners();
        AppFeedback.showSuccess('تم حذف المنتج بنجاح');
      }
    });
  }

  // --- Selection Methods ---
  void toggleSelectionMode([bool? enable]) {
    if (enable != null) {
      _isSelectionMode = enable;
    } else {
      _isSelectionMode = !_isSelectionMode;
    }
    if (!_isSelectionMode) {
      selectedProductIds.clear();
    }
    notifyListeners();
  }

  void toggleProductSelection(String id) {
    if (selectedProductIds.contains(id)) {
      selectedProductIds.remove(id);
    } else {
      selectedProductIds.add(id);
      if (!_isSelectionMode) {
        _isSelectionMode = true;
      }
    }
    notifyListeners();
  }

  bool isProductSelected(String id) => selectedProductIds.contains(id);

  void toggleSelectAll() {
    if (isAllSelected) {
      deselectAll();
    } else {
      selectAll();
    }
  }

  void selectAll() {
    selectedProductIds.addAll(filteredProducts.map((p) => p.id));
    _isSelectionMode = true;
    notifyListeners();
  }

  void deselectAll() {
    selectedProductIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  // --- Bulk Action Methods ---
  void confirmBulkDelete(BuildContext context) {
    final count = selectedProductIds.length;
    if (count == 0) return;

    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تأكيد الحذف الجماعي',
        message:
            'هل أنت متأكد من حذف $count منتج(ات) محدد بشكل نهائي؟ لا يمكن التراجع عن هذا الإجراء.',
        confirmText: 'حذف المحدد',
        confirmColor: Colors.redAccent,
        icon: Icons.delete_sweep_rounded,
        onConfirm: () {
          Navigator.of(ctx).pop();
          _executeBulkDelete();
        },
      ),
    );
  }

  Future<void> _executeBulkDelete() async {
    final idsToDelete = selectedProductIds.toList();
    if (idsToDelete.isEmpty || _isBulkOperating) return;

    _isBulkOperating = true;
    notifyListeners();

    int successCount = 0;
    int failCount = 0;

    for (final id in idsToDelete) {
      final result = await _deleteProductUseCase(id);
      final bool isSuccess = result.fold((l) => false, (r) => r);
      if (isSuccess) {
        products.removeWhere((p) => p.id == id);
        selectedProductIds.remove(id);
        successCount++;
      } else {
        failCount++;
      }
    }

    _applyFiltering();

    if (selectedProductIds.isEmpty) {
      _isSelectionMode = false;
    }

    if (failCount == 0) {
      AppFeedback.showSuccess('تم حذف $successCount منتج(ات) بنجاح');
    } else {
      AppFeedback.showWarning('تم حذف $successCount وفشل حذف $failCount منتج');
    }

    _isBulkOperating = false;
    notifyListeners();
  }

  Future<void> bulkToggleStatus({required bool activate}) async {
    final idsToUpdate = selectedProductIds.toList();
    if (idsToUpdate.isEmpty || _isBulkOperating) return;

    final actionName = activate ? 'تفعيل' : 'تعطيل';
    _isBulkOperating = true;
    notifyListeners();

    int successCount = 0;
    int failCount = 0;

    for (final id in idsToUpdate) {
      final result = await _updateProductUseCase(id, {'is_active': activate});
      result.fold((l) => failCount++, (updatedProduct) {
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = updatedProduct;
        }
        successCount++;
      });
    }

    _applyFiltering();

    if (failCount == 0) {
      AppFeedback.showSuccess('تم $actionName $successCount منتج(ات) بنجاح');
    } else {
      AppFeedback.showWarning(
        'تم $actionName $successCount وفشل $failCount منتج',
      );
    }

    _isBulkOperating = false;
    notifyListeners();
  }

  Future<void> bulkChangeCategory(String newCategoryId) async {
    final idsToUpdate = selectedProductIds.toList();
    if (idsToUpdate.isEmpty || _isBulkOperating) return;

    _isBulkOperating = true;
    notifyListeners();

    int successCount = 0;
    int failCount = 0;

    for (final id in idsToUpdate) {
      final result = await _updateProductUseCase(id, {
        'category_id': newCategoryId,
      });
      result.fold((l) => failCount++, (updatedProduct) {
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = updatedProduct;
        }
        successCount++;
      });
    }

    _applyFiltering();

    if (failCount == 0) {
      AppFeedback.showSuccess('تم نقل $successCount منتج(ات) إلى القسم بنجاح');
    } else {
      AppFeedback.showWarning('تم نقل $successCount وفشل نقل $failCount منتج');
    }

    _isBulkOperating = false;
    notifyListeners();
  }

  Future<String?> uploadImage(String filePath) async {
    if (_isUploadingImage) return null;

    _isUploadingImage = true;
    notifyListeners();

    final result = await _uploadProductImageUseCase(filePath);
    final uploadedUrl = result.fold<String?>((failure) {
      AppFeedback.showError(failure.toMessage());
      return null;
    }, (url) => url);

    _isUploadingImage = false;
    notifyListeners();
    return uploadedUrl;
  }

  void showProductForm(BuildContext context, {ProductEntity? product}) {
    context.push(AppRoutes.productForm, extra: product);
  }

  @override
  void dispose() {
    for (var c in textcontrollers.values) {
      c.dispose();
    }
    for (var c in sizePriceControllers.values) {
      c.dispose();
    }
    for (var c in sizeDiscountControllers.values) {
      c.dispose();
    }
    for (var c in sizeServingsControllers.values) {
      c.dispose();
    }
    for (var c in sizeWeightControllers.values) {
      c.dispose();
    }
    for (var c in sizeStockControllers.values) {
      c.dispose();
    }
    super.dispose();
  }
}
