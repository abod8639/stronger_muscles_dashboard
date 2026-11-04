import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/core/utils/weight_unit_helper.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/ai_product_suggestion_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/generate_product_suggestion_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/form_sections/category_picker/category_tree_utils.dart';
import '../helpers/product_flavor_helper.dart';
import 'product_filter_mixin.dart';
import 'product_form_fields_mixin.dart';
import 'product_sizes_mixin.dart';

/// Mixin adding Google Gemini AI capabilities to the ProductsController.
mixin ProductAiMixin
    on
        ChangeNotifier,
        ProductFilterMixin,
        ProductFormFieldsMixin,
        ProductSizesMixin {
  GenerateProductSuggestionUseCase get generateProductSuggestionUseCase;

  bool _isAiGenerating = false;
  bool get isAiGenerating => _isAiGenerating;

  /// Fetches comprehensive AI suggestions from Gemini for the given product name
  Future<AiProductSuggestionEntity?> fetchAiSuggestions(
    String productName,
  ) async {
    final trimmedName = productName.trim();
    if (trimmedName.isEmpty) {
      AppFeedback.showWarning('يرجى كتابة اسم المنتج أولاً لاستخدام الذكاء الاصطناعي');
      return null;
    }

    _isAiGenerating = true;
    notifyListeners();

    AiProductSuggestionEntity? suggestion;
    try {
      final availableCats = categories.map((c) => c.nameAr).toList();
      final availableBrandsList = brands.map((b) => b.displayName).toList();
      final availableStoreFlavors = ProductFlavorHelper.getAvailableStoreFlavors(
        existingProducts: products,
      );
      final flavorNames = availableStoreFlavors.map((f) => f.name).toList();

      final result = await generateProductSuggestionUseCase(
        productName: trimmedName,
        availableCategories: availableCats,
        availableBrands: availableBrandsList,
        availableFlavors: flavorNames,
      );

      result.fold(
        (failure) => AppFeedback.showError(failure.toMessage()),
        (data) => suggestion = data,
      );
    } finally {
      _isAiGenerating = false;
      notifyListeners();
    }
    return suggestion;
  }

  /// Applies the verified AI suggestions to the product form state
  void applyAiSuggestions(
    AiProductSuggestionEntity suggestion, {
    Set<String>? selectedFields,
    String? categoryIdToSet,
  }) {
    final fields = selectedFields ??
        {
          'names',
          'descriptions',
          'brand',
          'category',
          'nutrition',
          'allergens',
          'tags',
          'flavors',
          'sizes',
          'sku',
        };

    // 1. Names
    if (fields.contains('names')) {
      if (suggestion.nameAr.isNotEmpty) {
        textcontrollers['name_ar']?.text = suggestion.nameAr;
      }
      if (suggestion.nameEn.isNotEmpty) {
        textcontrollers['name_en']?.text = suggestion.nameEn;
      }
    }

    // 2. Descriptions
    if (fields.contains('descriptions')) {
      if (suggestion.descAr.isNotEmpty) {
        textcontrollers['desc_ar']?.text = suggestion.descAr;
      }
      if (suggestion.descEn.isNotEmpty) {
        textcontrollers['desc_en']?.text = suggestion.descEn;
      }
    }

    // 3. Brand
    if (fields.contains('brand') &&
        suggestion.brandName != null &&
        suggestion.brandName!.isNotEmpty) {
      textcontrollers['brand']?.text = suggestion.brandName!;
    }

    // 4. Category
    if (fields.contains('category')) {
      if (categoryIdToSet != null &&
          categoryIdToSet.isNotEmpty &&
          categoryIdToSet != 'all') {
        setFormCategoryId(categoryIdToSet);
      } else if (suggestion.suggestedCategory != null) {
        final flatCategories = CategoryTreeUtils.flatten(categories);
        final query = suggestion.suggestedCategory!.toLowerCase().trim();
        for (final cat in flatCategories) {
          if (cat.nameAr.toLowerCase().contains(query) ||
              cat.nameEn.toLowerCase().contains(query) ||
              query.contains(cat.nameAr.toLowerCase()) ||
              query.contains(cat.nameEn.toLowerCase())) {
            setFormCategoryId(cat.id);
            break;
          }
        }
      }
    }

    // 5. Nutrition Facts & Servings
    if (fields.contains('nutrition')) {
      if (suggestion.servingSize != null && suggestion.servingSize!.isNotEmpty) {
        textcontrollers['serving']?.text = suggestion.servingSize!;
      }
      if (suggestion.servingsPerContainer != null) {
        textcontrollers['sessions']?.text =
            suggestion.servingsPerContainer.toString();
      }
      if (suggestion.calories != null) {
        textcontrollers['calories']?.text = suggestion.calories!;
      }
      if (suggestion.protein != null) {
        textcontrollers['protein']?.text = suggestion.protein!;
      }
      if (suggestion.carbs != null) {
        textcontrollers['carbs']?.text = suggestion.carbs!;
      }
      if (suggestion.fat != null) {
        textcontrollers['fat']?.text = suggestion.fat!;
      }
      if (suggestion.sugar != null) {
        textcontrollers['sugar']?.text = suggestion.sugar!;
      }
    }

    // 6. Allergens
    if (fields.contains('allergens')) {
      for (final a in suggestion.allergens) {
        if (!allergens.contains(a)) {
          allergens.add(a);
        }
      }
    }

    // 7. Tags
    if (fields.contains('tags')) {
      for (final t in suggestion.tags) {
        addTag(t);
      }
    }

    // 8. Flavors (Strictly existing store flavors only)
    if (fields.contains('flavors')) {
      final storeFlavors = ProductFlavorHelper.getAvailableStoreFlavors(
        existingProducts: products,
      );
      final validFlavors = ProductFlavorHelper.filterOnlyExistingFlavors(
        suggestion.flavors,
        storeFlavors,
      );
      for (final f in validFlavors) {
        if (!productFlavors.contains(f)) {
          productFlavors.add(f);
        }
      }
    }

    // 9. Sizes (Strictly metric g - kg only)
    if (fields.contains('sizes')) {
      for (final s in suggestion.suggestedSizes) {
        final rawSizeName = s['size']?.toString().trim() ?? '';
        final sizeName = WeightUnitHelper.normalizeToMetric(rawSizeName);
        if (sizeName.isNotEmpty &&
            !productSizes.any((existing) => existing.size == sizeName)) {
          final dynamic rawServings = s['servings'];
          int? servings;
          if (rawServings is int) {
            servings = rawServings;
          } else if (rawServings != null) {
            servings = int.tryParse(rawServings.toString());
          }
          final rawWeight = s['weight']?.toString();
          final weight = rawWeight != null
              ? WeightUnitHelper.normalizeToMetric(rawWeight)
              : null;

          addProductSize(
            sizeName,
            0.0,
            null,
            servings: servings,
            weight: weight,
          );
        }
      }
    }

    // 10. SKU Prefix
    if (fields.contains('sku') &&
        suggestion.skuPrefix != null &&
        suggestion.skuPrefix!.isNotEmpty) {
      if (textcontrollers['sku']?.text.trim().isEmpty == true) {
        textcontrollers['sku']?.text =
            '${suggestion.skuPrefix}-${DateTime.now().millisecondsSinceEpoch % 10000}';
      }
    }

    markFormDirty();
    notifyListeners();
    AppFeedback.showSuccess('تم تطبيق مواصفات الذكاء الاصطناعي بنجاح ✨');
  }
}
