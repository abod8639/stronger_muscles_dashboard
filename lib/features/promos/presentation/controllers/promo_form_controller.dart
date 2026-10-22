import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

/// متحكم مخصص لإدارة نموذج إنشاء وتعديل الإعلانات الترويجية وفق معايير Clean Architecture
class PromoFormController extends ChangeNotifier {
  final PromoEntity? initialPromo;
  final AddPromoUseCase addPromoUseCase;
  final UpdatePromoUseCase updatePromoUseCase;
  final UploadPromoImageUseCase uploadPromoImageUseCase;
  final PromosController? promosController;
  final GetProductsUseCase? getProductsUseCase;
  final BrandRepository? brandRepository;

  PromoFormController({
    this.initialPromo,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.uploadPromoImageUseCase,
    this.promosController,
    this.getProductsUseCase,
    this.brandRepository,
  });

  bool get isEditing => initialPromo != null;

  // Form State — Text Controllers
  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  final subtitleArController = TextEditingController();
  final subtitleEnController = TextEditingController();
  final buttonArController = TextEditingController();
  final buttonEnController = TextEditingController();
  final backgroundColorController = TextEditingController();

  // State
  String _backgroundColorHex = '#FFFFFF';
  String get backgroundColorHex => _backgroundColorHex;
  set backgroundColorHex(String val) {
    _backgroundColorHex = val;
    notifyListeners();
  }

  String _selectedTargetType = 'none';
  String get selectedTargetType => _selectedTargetType;
  set selectedTargetType(String val) {
    _selectedTargetType = val;
    notifyListeners();
  }

  String? _selectedTargetId;
  String? get selectedTargetId => _selectedTargetId;
  set selectedTargetId(String? val) {
    _selectedTargetId = val;
    notifyListeners();
  }

  bool _isActive = true;
  bool get isActive => _isActive;
  set isActive(bool val) {
    _isActive = val;
    notifyListeners();
  }

  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  set selectedImage(File? val) {
    _selectedImage = val;
    notifyListeners();
  }

  String _existingImageUrl = '';
  String get existingImageUrl => _existingImageUrl;
  set existingImageUrl(String val) {
    _existingImageUrl = val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isBrandsLoading = false;
  bool get isBrandsLoading => _isBrandsLoading;

  // Cache & Reference Lists
  List<ProductEntity> _products = [];
  List<ProductEntity> get products => _products;

  List<BrandEntity> _brands = [];
  List<BrandEntity> get brands => _brands;

  void init() {
    _initFormValues();
    _loadDependencies();

    backgroundColorController.addListener(() {
      _backgroundColorHex = backgroundColorController.text;
      notifyListeners();
    });
  }

  void _initFormValues() {
    if (initialPromo != null) {
      final promo = initialPromo!;
      titleArController.text = promo.title?['ar']?.toString() ?? '';
      titleEnController.text = promo.title?['en']?.toString() ?? '';
      subtitleArController.text = promo.subtitle?['ar']?.toString() ?? '';
      subtitleEnController.text = promo.subtitle?['en']?.toString() ?? '';
      buttonArController.text = promo.buttonText?['ar']?.toString() ?? '';
      buttonEnController.text = promo.buttonText?['en']?.toString() ?? '';
      backgroundColorController.text = promo.backgroundColor;
      _backgroundColorHex = promo.backgroundColor;

      _selectedTargetType = promo.targetType;
      _selectedTargetId = promo.targetId;
      _isActive = promo.isActive;
      _existingImageUrl = promo.imageUrl;
    } else {
      backgroundColorController.text = '#FFFFFF';
      _backgroundColorHex = '#FFFFFF';
      _selectedTargetType = 'none';
      _selectedTargetId = null;
      _isActive = true;
    }
  }

  Future<void> _loadDependencies() async {
    if (promosController != null) {
      _products = List.from(promosController!.products);
      _brands = List.from(promosController!.brands);
      _isBrandsLoading = promosController!.isBrandsLoading;
      notifyListeners();
    }

    if (_products.isEmpty && getProductsUseCase != null) {
      try {
        final result = await getProductsUseCase!.call();
        result.fold(
          (failure) {},
          (fetched) {
            _products = fetched;
            notifyListeners();
          },
        );
      } catch (_) {}
    }

    if (_brands.isEmpty && brandRepository != null) {
      _isBrandsLoading = true;
      notifyListeners();
      try {
        final fetched = await brandRepository!.getBrands();
        _brands = fetched;
      } catch (_) {
      } finally {
        _isBrandsLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void setPresetColor(String hex) {
    backgroundColorController.text = hex;
    _backgroundColorHex = hex;
    notifyListeners();
  }

  Future<void> savePromo([BuildContext? context]) async {
    if (_existingImageUrl.isEmpty && _selectedImage == null) {
      AppFeedback.showError('يجب اختيار صورة للإعلان');
      return;
    }

    // التحقق من صحة توجيه الإعلان
    if (_selectedTargetType == 'product' &&
        (_selectedTargetId == null || _selectedTargetId!.isEmpty)) {
      AppFeedback.showError('يجب اختيار منتج للإعلان');
      return;
    }

    if (_selectedTargetType == 'brand' &&
        (_selectedTargetId == null || _selectedTargetId!.isEmpty)) {
      AppFeedback.showError('يجب اختيار ماركة للإعلان');
      return;
    }

    _isLoading = true;
    notifyListeners();

    String finalImageUrl = _existingImageUrl;
    try {
      if (_selectedImage != null) {
        finalImageUrl =
            await uploadPromoImageUseCase.call(_selectedImage!.path);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      AppFeedback.showError('فشل في رفع الصورة: ${e.toString()}');
      return;
    }

    final targetId =
        _selectedTargetType == 'none' ? null : _selectedTargetId;

    final promoData = PromoEntity(
      id: initialPromo?.id ?? '',
      title: {
        'ar': titleArController.text.trim(),
        'en': titleEnController.text.trim()
      },
      subtitle: {
        'ar': subtitleArController.text.trim(),
        'en': subtitleEnController.text.trim()
      },
      buttonText: {
        'ar': buttonArController.text.trim(),
        'en': buttonEnController.text.trim()
      },
      imageUrl: finalImageUrl,
      backgroundColor: backgroundColorController.text.isNotEmpty
          ? backgroundColorController.text
          : '#FFFFFF',
      targetType: _selectedTargetType,
      targetId: targetId,
      isActive: _isActive,
    );

    try {
      if (isEditing) {
        final updated = await updatePromoUseCase.call(promoData);
        promosController?.updatePromoLocally(updated);
        AppFeedback.showSuccess('تم تحديث الإعلان بنجاح');
      } else {
        final added = await addPromoUseCase.call(promoData);
        promosController?.updatePromoLocally(added);
        AppFeedback.showSuccess('تمت إضافة الإعلان بنجاح');
      }
      if (context != null && context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      AppFeedback.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleArController.dispose();
    titleEnController.dispose();
    subtitleArController.dispose();
    subtitleEnController.dispose();
    buttonArController.dispose();
    buttonEnController.dispose();
    backgroundColorController.dispose();
    super.dispose();
  }
}
