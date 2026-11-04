import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import '../helpers/product_form_payload_builder.dart';
import 'product_filter_mixin.dart';
import 'product_form_fields_mixin.dart';
import 'product_media_mixin.dart';
import 'product_sizes_mixin.dart';
import 'product_variants_mixin.dart';

/// Mixin managing product form submission, brand auto-creation, and persistence use cases.
mixin ProductSaveMixin
    on
        ChangeNotifier,
        ProductFilterMixin,
        ProductFormFieldsMixin,
        ProductMediaMixin,
        ProductSizesMixin,
        ProductVariantsMixin {
  AddProductUseCase get addProductUseCase;
  UpdateProductUseCase get updateProductUseCase;

  bool _isSaving = false;
  bool get isSaving => _isSaving;
  set isSaving(bool v) {
    if (_isSaving != v) {
      _isSaving = v;
      notifyListeners();
    }
  }

  /// Validates, prepares, and persists the product data via domain use cases
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

    try {
      final enteredBrand = textcontrollers['brand']?.text.trim() ?? '';
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
        final createResult = await brandRepository.createBrand({
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

      // Build structured payload
      final productData = ProductFormPayloadBuilder.build(
        existingProduct: existingProduct,
        categoryId: categoryId,
        productImages: productImages,
        textControllers: textcontrollers,
        productSizes: productSizes,
        sizePriceControllers: sizePriceControllers,
        sizeDiscountControllers: sizeDiscountControllers,
        sizeServingsControllers: sizeServingsControllers,
        sizeWeightControllers: sizeWeightControllers,
        sizeStockControllers: sizeStockControllers,
        variants: variants,
        productFlavors: productFlavors,
        tags: tags,
        allergens: allergens,
        isActive: isActive,
        isFeatured: isFeatured,
        newArrival: newArrival,
        bestSeller: bestSeller,
        isBackgroundWhite: isBackgroundWhite,
        matchedBrandId: matchedBrand?.id,
      );

      bool isSuccess = false;
      if (existingProduct == null) {
        final result = await addProductUseCase(productData);
        isSuccess = result.fold<bool>(
          (failure) {
            AppFeedback.showError(failure.toMessage());
            return false;
          },
          (newProduct) {
            products.insert(0, newProduct);
            AppFeedback.showSuccess('تم إضافة المنتج بنجاح');
            applyFiltering();
            notifyListeners();
            return true;
          },
        );
      } else {
        final result = await updateProductUseCase(
          existingProduct.id,
          productData,
        );
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
            applyFiltering();
            notifyListeners();
            return true;
          },
        );
      }

      if (isSuccess) {
        resetFormDirty();
      }
      return isSuccess;
    } catch (e, stack) {
      debugPrint('Save product error: $e\n$stack');
      AppFeedback.showError('حدث خطأ غير متوقع أثناء الحفظ: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
