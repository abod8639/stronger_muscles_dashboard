import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

/// Mixin managing basic product form fields, text controllers, flags, and dirty state.
mixin ProductFormFieldsMixin on ChangeNotifier {
  bool _isFormDirty = false;
  bool get isFormDirty => _isFormDirty;

  void markFormDirty() {
    if (!_isFormDirty) {
      _isFormDirty = true;
      notifyListeners();
    }
  }

  void resetFormDirty() {
    _isFormDirty = false;
  }

  // --- Basic Form Text Controllers ---
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
    'manufacturer_url': TextEditingController(),
  };

  // --- Form Attributes & Flags ---
  String? _formCategoryId;
  String? get formCategoryId => _formCategoryId;

  void setFormCategoryId(String? id) {
    final clean =
        (id != null && id.trim().isNotEmpty && id != 'all') ? id.trim() : null;
    if (_formCategoryId != clean) {
      _formCategoryId = clean;
      _isFormDirty = true;
      notifyListeners();
    }
  }

  final List<String> productFlavors = [];
  final List<String> tags = [];
  final List<String> allergens = [];

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

  void updateProductFlavors(List<String> newFlavors) {
    productFlavors
      ..clear()
      ..addAll(newFlavors);
    _isFormDirty = true;
    notifyListeners();
  }

  /// Initializes all form field controllers and flags with product data
  void initFormFields(ProductEntity? product) {
    productFlavors.clear();
    tags.clear();
    allergens.clear();

    if (product != null) {
      _formCategoryId = product.categoryId;
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
      textcontrollers['manufacturer_url']?.clear();

      // Populate nutrition facts
      final facts = product.nutritionFacts;
      if (facts != null) {
        textcontrollers['calories']?.text = facts['calories']?.toString() ?? '';
        textcontrollers['protein']?.text = facts['protein']?.toString() ?? '';
        textcontrollers['carbs']?.text = facts['carbs']?.toString() ?? '';
        textcontrollers['fat']?.text = facts['fat']?.toString() ?? '';
        textcontrollers['sugar']?.text = facts['sugar']?.toString() ?? '';
        if (facts['allergens'] is List) {
          allergens.addAll(
            (facts['allergens'] as List).map((e) => e.toString()),
          );
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
      _newArrival = product.newArrival;
      _bestSeller = product.bestSeller;

      if (product.flavors != null) {
        productFlavors.addAll(product.flavors!);
      }
    } else {
      _formCategoryId = null;
      for (var c in textcontrollers.values) {
        c.clear();
      }
      _isFeatured = false;
      _isActive = true;
      _newArrival = false;
      _bestSeller = false;
    }
  }

  /// Clears all field controllers and resets all attributes
  void clearFormFields() {
    _formCategoryId = null;
    for (var c in textcontrollers.values) {
      c.clear();
    }
    productFlavors.clear();
    tags.clear();
    allergens.clear();
    _isFeatured = false;
    _isActive = true;
    _newArrival = false;
    _bestSeller = false;
  }

  /// Properly disposes all text editing controllers to prevent memory leaks
  void disposeFormFields() {
    for (var c in textcontrollers.values) {
      c.dispose();
    }
  }
}
