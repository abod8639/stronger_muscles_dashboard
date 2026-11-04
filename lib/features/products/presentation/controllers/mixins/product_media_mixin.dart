import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/upload_product_image_usecase.dart';

/// Mixin managing product images, media uploads, and presentation flags.
mixin ProductMediaMixin on ChangeNotifier {
  UploadProductImageUseCase get uploadProductImageUseCase;
  void markFormDirty();

  bool _isUploadingImage = false;
  bool get isUploadingImage => _isUploadingImage;
  set isUploadingImage(bool v) {
    if (_isUploadingImage != v) {
      _isUploadingImage = v;
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

  final List<String> imageUrls = [];

  void addImageUrl(String url) {
    imageUrls.add(url);
    markFormDirty();
    notifyListeners();
  }

  void removeImageUrl(int index) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls.removeAt(index);
      markFormDirty();
      notifyListeners();
    }
  }

  void reorderImageUrl(int oldIndex, int newIndex) {
    if (oldIndex >= 0 && oldIndex < imageUrls.length) {
      final item = imageUrls.removeAt(oldIndex);
      imageUrls.insert(newIndex, item);
      markFormDirty();
      notifyListeners();
    }
  }

  Future<String?> uploadImage(String filePath) async {
    if (_isUploadingImage) return null;

    _isUploadingImage = true;
    notifyListeners();

    final result = await uploadProductImageUseCase(filePath);
    final uploadedUrl = result.fold<String?>((failure) {
      AppFeedback.showError(failure.toMessage());
      return null;
    }, (url) => url);

    _isUploadingImage = false;
    notifyListeners();
    return uploadedUrl;
  }

  void initMediaForProduct(ProductEntity? product) {
    imageUrls.clear();
    if (product != null) {
      imageUrls.addAll(product.imageUrls);
      _isBackgroundWhite = product.isBackgroundWhite ?? false;
    } else {
      _isBackgroundWhite = false;
    }
  }

  void clearMedia() {
    imageUrls.clear();
    _isBackgroundWhite = false;
  }
}
