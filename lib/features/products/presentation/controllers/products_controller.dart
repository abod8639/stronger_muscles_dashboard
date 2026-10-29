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
  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadProductImageUseCase _uploadProductImageUseCase;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UploadProductImageUseCase uploadProductImageUseCase,
    required CategoryRepository categoryRepository,
    required BrandRepository brandRepository,
  })  : _getProductsUseCase = getProductsUseCase,
        _addProductUseCase = addProductUseCase,
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
  };

  // Controllers for each size
  final Map<String, TextEditingController> sizePriceControllers = {};
  final Map<String, TextEditingController> sizeDiscountControllers = {};

  Future<void> fetchData({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();

    final catResult = await _categoryRepository.getCategories(tree: true);
    catResult.fold(
      (failure) => debugPrint('Error categories: ${failure.toMessage()}'),
      (cats) {
        categories
          ..clear()
          ..addAll(cats);
      },
    );

    final prodResult = await _getProductsUseCase(forceRefresh: forceRefresh);
    prodResult.fold(
      (failure) => AppFeedback.showError(failure.toMessage()),
      (prods) {
        products
          ..clear()
          ..addAll(prods);
      },
    );

    final brandsResult = await _brandRepository.getBrands();
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
          final matchesCategory = _selectedCategoryId == 'all' ||
              product.categoryId == _selectedCategoryId;

          final matchesFlavor = _selectedFlavorId == 'all' ||
              (product.flavors != null &&
                  product.flavors!.contains(_selectedFlavorId));

          final matchesSearch = query.isEmpty ||
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
    selectedProductIds.clear();

    if (product != null) {
      textcontrollers['name_ar']?.text = product.nameAr;
      textcontrollers['name_en']?.text = product.nameEn;
      textcontrollers['price']?.text = product.price.toString();
      textcontrollers['discount']?.text = product.discountPrice?.toString() ?? '';
      textcontrollers['desc_ar']?.text = product.descriptionAr;
      textcontrollers['desc_en']?.text = product.descriptionEn;
      textcontrollers['stock']?.text = product.stockQuantity.toString();
      textcontrollers['brand']?.text = product.brand ?? '';
      textcontrollers['serving']?.text = product.servingSize ?? '';
      textcontrollers['sessions']?.text =
          product.servingsPerContainer?.toString() ?? '';

      _isFeatured = product.isFeatured;
      _isActive = product.isActive;
      _isBackgroundWhite = product.isBackgroundWhite ?? false;

      imageUrls.addAll(product.imageUrls);

      if (product.productSizes != null) {
        for (var ps in product.productSizes!) {
          productSizes.add(ps);
          sizePriceControllers[ps.size] =
              TextEditingController(text: ps.price.toString());
          sizeDiscountControllers[ps.size] =
              TextEditingController(text: ps.discountPrice?.toString() ?? '');
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
    }
    notifyListeners();
  }

  void addProductSize(String size, double price, double? discount) {
    final newSize = ProductSizeEntity(size: size, price: price, discountPrice: discount);
    productSizes.add(newSize);
    sizePriceControllers[size] = TextEditingController(text: price.toString());
    sizeDiscountControllers[size] =
        TextEditingController(text: discount?.toString() ?? '');
    notifyListeners();
  }

  void removeProductSize(int index) {
    if (index >= 0 && index < productSizes.length) {
      final size = productSizes[index].size;
      sizePriceControllers[size]?.dispose();
      sizePriceControllers.remove(size);
      sizeDiscountControllers[size]?.dispose();
      sizeDiscountControllers.remove(size);
      productSizes.removeAt(index);
      notifyListeners();
    }
  }

  void selectSize(int index) {
    selectedSizeIndex = index;
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
  }

  void addNewVariant() {
    final newVariant = ProductVariantEntity(
      id: 'VAR-${DateTime.now().millisecondsSinceEpoch}',
      sku: 'SKU-${DateTime.now().millisecondsSinceEpoch % 10000}',
      price: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      discountPrice: double.tryParse(textcontrollers['discount']?.text ?? ''),
      effectivePrice: double.tryParse(textcontrollers['price']?.text ?? '0') ?? 0.0,
      stockQuantity: int.tryParse(textcontrollers['stock']?.text ?? '0') ?? 0,
      attributes: const {},
      isActive: true,
    );
    variants.add(newVariant);
    notifyListeners();
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
      final discount =
          double.tryParse(sizeDiscountControllers[ps.size]?.text ?? '');
      return ProductSizeEntity(
        size: ps.size,
        price: price,
        discountPrice: discount,
      );
    }).toList();

    double mainPrice = double.tryParse(textcontrollers['price']!.text) ?? 0.0;
    double? discountPrice = double.tryParse(textcontrollers['discount']!.text);

    if (mainPrice == 0 && updatedSizes.isNotEmpty) {
      mainPrice = updatedSizes.first.price;
      discountPrice = updatedSizes.first.discountPrice;
    }

    final String generatedId = existingProduct?.id ??
        'PROD-${DateTime.now().millisecondsSinceEpoch}';

    final productData = {
      'id': generatedId,
      'name': {
        'ar': textcontrollers['name_ar']!.text.trim(),
        'en': textcontrollers['name_en']!.text.trim(),
      },
      'description': {
        'ar': textcontrollers['desc_ar']!.text.trim(),
        'en': textcontrollers['desc_en']!.text.trim(),
      },
      'price': mainPrice,
      'discount_price': discountPrice,
      'image_urls': productImages,
      'category_id': categoryId,
      'stock_quantity': int.tryParse(textcontrollers['stock']!.text) ?? 0,
      'brand': textcontrollers['brand']!.text.trim(),
      'is_active': _isActive,
      'featured': _isFeatured,
      'is_background_white': _isBackgroundWhite,
      'serving_size': textcontrollers['serving']!.text.trim(),
      'servings_per_container':
          int.tryParse(textcontrollers['sessions']!.text) ?? 0,
      'flavors': productFlavors.toList(),
      'product_sizes': updatedSizes
          .map((s) => {
                'size': s.size,
                'price': s.price,
                'discount_price': s.discountPrice,
              })
          .toList(),
      'product_variants': variants
          .map((v) => {
                'id': v.id,
                'sku': v.sku,
                'price': v.price,
                'discount_price': v.discountPrice,
                'effective_price': v.effectivePrice,
                'stock_quantity': v.stockQuantity,
                'attributes': v.attributes,
                'is_active': v.isActive,
              })
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
      final result =
          await _updateProductUseCase(existingProduct.id, productData);
      isSuccess = result.fold<bool>(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (updatedProduct) {
          final index =
              products.indexWhere((p) => p.id == existingProduct.id);
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
    result.fold(
      (failure) => AppFeedback.showError(failure.toMessage()),
      (success) {
        if (success) {
          products.removeWhere((p) => p.id == id);
          _applyFiltering();
          notifyListeners();
          AppFeedback.showSuccess('تم حذف المنتج بنجاح');
        }
      },
    );
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
      final result =
          await _updateProductUseCase(id, {'is_active': activate});
      result.fold(
        (l) => failCount++,
        (updatedProduct) {
          final index = products.indexWhere((p) => p.id == id);
          if (index != -1) {
            products[index] = updatedProduct;
          }
          successCount++;
        },
      );
    }

    _applyFiltering();

    if (failCount == 0) {
      AppFeedback.showSuccess('تم $actionName $successCount منتج(ات) بنجاح');
    } else {
      AppFeedback.showWarning('تم $actionName $successCount وفشل $failCount منتج');
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
      final result = await _updateProductUseCase(
          id, {'category_id': newCategoryId});
      result.fold(
        (l) => failCount++,
        (updatedProduct) {
          final index = products.indexWhere((p) => p.id == id);
          if (index != -1) {
            products[index] = updatedProduct;
          }
          successCount++;
        },
      );
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
    final uploadedUrl = result.fold<String?>(
      (failure) {
        AppFeedback.showError(failure.toMessage());
        return null;
      },
      (url) => url,
    );

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
    super.dispose();
  }
}
