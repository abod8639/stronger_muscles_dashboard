import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'product_form_fields_mixin.dart';

/// Mixin managing product size variations and their associated per-size form controllers.
mixin ProductSizesMixin on ChangeNotifier, ProductFormFieldsMixin {
  final List<ProductSizeEntity> productSizes = [];

  int _selectedSizeIndex = -1;
  int get selectedSizeIndex => _selectedSizeIndex;
  set selectedSizeIndex(int v) {
    if (_selectedSizeIndex != v) {
      _selectedSizeIndex = v;
      notifyListeners();
    }
  }

  // Dynamic controllers for each size
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

  void notifySizeStockChanged() {
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
      flavors:
          flavors ??
          (productFlavors.isNotEmpty ? List<String>.from(productFlavors) : null),
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
    markFormDirty();
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
      markFormDirty();
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
      markFormDirty();
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
    markFormDirty();
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

  void syncSizeControllers({bool notify = true}) {
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
    if (notify) {
      notifyListeners();
    }
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

  void disposeSizeControllers() {
    clearSizeControllers();
  }

  void initSizesForProduct(ProductEntity? product) {
    clearSizeControllers();
    productSizes.clear();
    _selectedSizeIndex = -1;

    if (product != null && product.productSizes != null) {
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
  }
}
