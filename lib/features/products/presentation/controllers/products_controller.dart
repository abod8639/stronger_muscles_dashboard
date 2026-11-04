import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/gemini_product_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/ai_product_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/generate_product_suggestion_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/upload_product_image_usecase.dart';
import 'helpers/product_sku_generator.dart';
import 'mixins/product_ai_mixin.dart';
import 'mixins/product_filter_mixin.dart';
import 'mixins/product_form_fields_mixin.dart';
import 'mixins/product_media_mixin.dart';
import 'mixins/product_save_mixin.dart';
import 'mixins/product_selection_mixin.dart';
import 'mixins/product_sizes_mixin.dart';
import 'mixins/product_variants_mixin.dart';

export 'helpers/product_form_payload_builder.dart';
export 'helpers/product_sku_generator.dart';
export 'mixins/product_ai_mixin.dart';
export 'mixins/product_filter_mixin.dart';
export 'mixins/product_form_fields_mixin.dart';
export 'mixins/product_media_mixin.dart';
export 'mixins/product_save_mixin.dart';
export 'mixins/product_selection_mixin.dart';
export 'mixins/product_sizes_mixin.dart';
export 'mixins/product_variants_mixin.dart';

/// Pure Controller managing product UI presentation, form interactions, and bulk operations.
/// Follows Clean Architecture and SOLID principles by composing modular, focused mixins.
class ProductsController extends ChangeNotifier
    with
        ProductFilterMixin,
        ProductSelectionMixin,
        ProductFormFieldsMixin,
        ProductMediaMixin,
        ProductSizesMixin,
        ProductVariantsMixin,
        ProductSaveMixin,
        ProductAiMixin {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadProductImageUseCase _uploadProductImageUseCase;
  final CategoryRepository _categoryRepository;
  final BrandRepository _brandRepository;
  final GenerateProductSuggestionUseCase? _generateProductSuggestionUseCase;

  ProductsController({
    GetProductsUseCase? getProductsUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UploadProductImageUseCase uploadProductImageUseCase,
    required CategoryRepository categoryRepository,
    required BrandRepository brandRepository,
    GenerateProductSuggestionUseCase? generateProductSuggestionUseCase,
  }) : _addProductUseCase = addProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       _uploadProductImageUseCase = uploadProductImageUseCase,
       _categoryRepository = categoryRepository,
       _brandRepository = brandRepository,
       _generateProductSuggestionUseCase = generateProductSuggestionUseCase {
    fetchData();
  }

  // --- Contract Implementations for Mixins ---
  @override
  AddProductUseCase get addProductUseCase => _addProductUseCase;

  @override
  UpdateProductUseCase get updateProductUseCase => _updateProductUseCase;

  @override
  DeleteProductUseCase get deleteProductUseCase => _deleteProductUseCase;

  @override
  UploadProductImageUseCase get uploadProductImageUseCase =>
      _uploadProductImageUseCase;

  @override
  CategoryRepository get categoryRepository => _categoryRepository;

  @override
  BrandRepository get brandRepository => _brandRepository;

  @override
  GenerateProductSuggestionUseCase get generateProductSuggestionUseCase =>
      _generateProductSuggestionUseCase ??
      GenerateProductSuggestionUseCase(
        AiProductRepositoryImpl(GeminiProductRemoteDataSourceImpl()),
      );

  // --- Form Initialization & Lifecycle ---
  void initForForm({ProductEntity? product}) {
    resetFormDirty();
    initFormFields(product);
    initMediaForProduct(product);
    initSizesForProduct(product);
    initVariantsForProduct(product);
    selectedProductIds.clear();
    notifyListeners();
  }

  /// Completely resets all form controllers, media, sizes, and variants
  void clearForm() {
    resetFormDirty();
    clearFormFields();
    clearMedia();
    clearSizeControllers();
    clearVariants();
    selectedSizeIndex = -1;
    notifyListeners();
  }

  // --- Single Item Operations ---
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
          executeDelete(id);
        },
      ),
    );
  }

  Future<void> executeDelete(String id) async {
    final result = await _deleteProductUseCase(id);
    result.fold(
      (failure) => AppFeedback.showError(failure.toMessage()),
      (success) {
        if (success) {
          products.removeWhere((p) => p.id == id);
          applyFiltering();
          notifyListeners();
          AppFeedback.showSuccess('تم حذف المنتج بنجاح');
        }
      },
    );
  }

  static String slugifySku(String input) => ProductSkuGenerator.slugify(input);

  // --- Navigation ---
  void showProductForm(BuildContext context, {ProductEntity? product}) {
    context.push(AppRoutes.productForm, extra: product);
  }

  @override
  void dispose() {
    disposeFilter();
    disposeFormFields();
    disposeSizeControllers();
    super.dispose();
  }
}
