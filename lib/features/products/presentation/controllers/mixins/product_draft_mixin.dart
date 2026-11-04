import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_draft_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_draft_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_product_drafts_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/save_product_draft_usecase.dart';
import 'product_filter_mixin.dart';
import 'product_form_fields_mixin.dart';
import 'product_media_mixin.dart';
import 'product_sizes_mixin.dart';
import 'product_variants_mixin.dart';

/// Mixin managing product drafts persistence, restoration, and deletion.
mixin ProductDraftMixin
    on
        ChangeNotifier,
        ProductFilterMixin,
        ProductFormFieldsMixin,
        ProductMediaMixin,
        ProductSizesMixin,
        ProductVariantsMixin {
  GetProductDraftsUseCase get getProductDraftsUseCase;
  SaveProductDraftUseCase get saveProductDraftUseCase;
  DeleteProductDraftUseCase get deleteProductDraftUseCase;

  final List<ProductDraftEntity> drafts = [];
  bool _isLoadingDrafts = false;
  bool get isLoadingDrafts => _isLoadingDrafts;

  String? _activeDraftId;
  String? get activeDraftId => _activeDraftId;

  /// Loads all locally saved drafts ordered by newest first
  Future<void> loadDrafts() async {
    _isLoadingDrafts = true;
    notifyListeners();

    try {
      final result = await getProductDraftsUseCase();
      result.fold(
        (failure) {
          debugPrint('⚠️ Error loading product drafts: ${failure.toMessage()}');
        },
        (loaded) {
          drafts
            ..clear()
            ..addAll(loaded);
        },
      );
    } finally {
      _isLoadingDrafts = false;
      notifyListeners();
    }
  }

  /// Saves the current form state as a local draft without validating mandatory fields
  Future<ProductDraftEntity?> saveCurrentFormAsDraft({
    String? existingProductId,
    String? customTitle,
  }) async {
    // 1. Determine title
    final nameAr = textcontrollers['name_ar']?.text.trim() ?? '';
    final nameEn = textcontrollers['name_en']?.text.trim() ?? '';
    final now = DateTime.now();

    String title;
    if (customTitle != null && customTitle.trim().isNotEmpty) {
      title = customTitle.trim();
    } else if (nameAr.isNotEmpty) {
      title = nameAr;
    } else if (nameEn.isNotEmpty) {
      title = nameEn;
    } else {
      final formattedTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      title = 'مسودة بدون عنوان ($formattedTime)';
    }

    // 2. Snapshot form fields
    final fieldsSnapshot = <String, String>{};
    for (final entry in textcontrollers.entries) {
      final val = entry.value.text.trim();
      if (val.isNotEmpty) {
        fieldsSnapshot[entry.key] = val;
      }
    }

    // 3. Snapshot sizes and their dynamic controllers
    final sizeControllersSnapshot = <String, Map<String, String>>{};
    for (final s in productSizes) {
      sizeControllersSnapshot[s.size] = {
        'price': sizePriceControllers[s.size]?.text.trim() ?? '',
        'discount': sizeDiscountControllers[s.size]?.text.trim() ?? '',
        'servings': sizeServingsControllers[s.size]?.text.trim() ?? '',
        'weight': sizeWeightControllers[s.size]?.text.trim() ?? '',
        'stock': sizeStockControllers[s.size]?.text.trim() ?? '',
      };
    }

    final draftId =
        _activeDraftId ?? 'draft_${now.millisecondsSinceEpoch}';

    final draft = ProductDraftEntity(
      id: draftId,
      title: title,
      updatedAt: now,
      existingProductId: existingProductId,
      categoryId: formCategoryId,
      formFields: fieldsSnapshot,
      imageUrls: List<String>.from(imageUrls),
      productSizes: List<ProductSizeEntity>.from(productSizes),
      sizeControllerValues: sizeControllersSnapshot,
      variants: List<ProductVariantEntity>.from(variants),
      productFlavors: List<String>.from(productFlavors),
      tags: List<String>.from(tags),
      allergens: List<String>.from(allergens),
      isActive: isActive,
      isFeatured: isFeatured,
      newArrival: newArrival,
      bestSeller: bestSeller,
      isBackgroundWhite: isBackgroundWhite,
    );

    final result = await saveProductDraftUseCase(draft);
    ProductDraftEntity? savedDraft;

    result.fold(
      (failure) {
        AppFeedback.showError('تعذر حفظ المسودة: ${failure.toMessage()}');
      },
      (saved) {
        savedDraft = saved;
        _activeDraftId = saved.id;
        final existingIdx = drafts.indexWhere((d) => d.id == saved.id);
        if (existingIdx >= 0) {
          drafts[existingIdx] = saved;
        } else {
          drafts.insert(0, saved);
        }
        resetFormDirty();
        notifyListeners();
        AppFeedback.showSuccess('تم حفظ المسودة بنجاح: "$title"');
      },
    );

    return savedDraft;
  }

  /// Restores the selected draft into the current form state
  void restoreDraft(ProductDraftEntity draft) {
    _activeDraftId = draft.id;

    // Reset current form without disposing
    for (final c in textcontrollers.values) {
      c.clear();
    }
    imageUrls.clear();
    productFlavors.clear();
    tags.clear();
    allergens.clear();
    clearSizeControllers();
    clearVariants();

    // 1. Populate text controllers
    for (final entry in draft.formFields.entries) {
      if (textcontrollers.containsKey(entry.key)) {
        textcontrollers[entry.key]?.text = entry.value;
      }
    }

    // 2. Category
    setFormCategoryId(draft.categoryId);

    // 3. Media
    imageUrls.addAll(draft.imageUrls);

    // 4. Flavors, tags, allergens
    productFlavors.addAll(draft.productFlavors);
    tags.addAll(draft.tags);
    allergens.addAll(draft.allergens);

    // 5. Flags
    isActive = draft.isActive;
    isFeatured = draft.isFeatured;
    newArrival = draft.newArrival;
    bestSeller = draft.bestSeller;
    isBackgroundWhite = draft.isBackgroundWhite;

    // 6. Sizes and size controllers
    for (final s in draft.productSizes) {
      final ctrlValues = draft.sizeControllerValues[s.size];
      final price = double.tryParse(ctrlValues?['price'] ?? '') ?? s.price;
      final discount = double.tryParse(ctrlValues?['discount'] ?? '') ?? s.discountPrice;
      final servings = int.tryParse(ctrlValues?['servings'] ?? '') ?? s.servings;
      final weight = ctrlValues?['weight'] ?? s.weight;
      final stock = int.tryParse(ctrlValues?['stock'] ?? '') ?? s.stockQuantity;

      addProductSize(
        s.size,
        price,
        discount,
        servings: servings,
        weight: weight,
        stockQuantity: stock,
        flavors: s.flavors,
      );
    }

    // 7. Variants
    variants.addAll(draft.variants);

    markFormDirty();
    notifyListeners();
    AppFeedback.showSuccess('تمت استعادة المسودة: "${draft.title}"');
  }

  /// Deletes a specific draft
  Future<bool> removeDraft(String draftId) async {
    final result = await deleteProductDraftUseCase(draftId);
    bool deleted = false;

    result.fold(
      (failure) {
        AppFeedback.showError('تعذر حذف المسودة: ${failure.toMessage()}');
      },
      (_) {
        deleted = true;
        drafts.removeWhere((d) => d.id == draftId);
        if (_activeDraftId == draftId) {
          _activeDraftId = null;
        }
        notifyListeners();
        AppFeedback.showSuccess('تم حذف المسودة بنجاح');
      },
    );

    return deleted;
  }

  /// Resets the active draft reference when clearing or starting fresh
  void resetActiveDraft() {
    _activeDraftId = null;
  }
}
