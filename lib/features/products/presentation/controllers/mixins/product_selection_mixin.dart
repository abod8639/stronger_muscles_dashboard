import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'product_filter_mixin.dart';

/// Mixin managing multi-select state and bulk operations (batch delete, status toggle, category reassignment).
mixin ProductSelectionMixin on ChangeNotifier, ProductFilterMixin {
  DeleteProductUseCase get deleteProductUseCase;
  UpdateProductUseCase get updateProductUseCase;

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
          executeBulkDelete();
        },
      ),
    );
  }

  Future<void> executeBulkDelete() async {
    final idsToDelete = selectedProductIds.toList();
    if (idsToDelete.isEmpty || _isBulkOperating) return;

    _isBulkOperating = true;
    notifyListeners();

    int successCount = 0;
    int failCount = 0;

    for (final id in idsToDelete) {
      final result = await deleteProductUseCase(id);
      final bool isSuccess = result.fold((l) => false, (r) => r);
      if (isSuccess) {
        products.removeWhere((p) => p.id == id);
        selectedProductIds.remove(id);
        successCount++;
      } else {
        failCount++;
      }
    }

    applyFiltering();

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
      final result = await updateProductUseCase(id, {'is_active': activate});
      result.fold((l) => failCount++, (updatedProduct) {
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = updatedProduct;
        }
        successCount++;
      });
    }

    applyFiltering();

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
      final result = await updateProductUseCase(id, {
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

    applyFiltering();

    if (failCount == 0) {
      AppFeedback.showSuccess('تم نقل $successCount منتج(ات) إلى القسم بنجاح');
    } else {
      AppFeedback.showWarning('تم نقل $successCount وفشل نقل $failCount منتج');
    }

    _isBulkOperating = false;
    notifyListeners();
  }
}
