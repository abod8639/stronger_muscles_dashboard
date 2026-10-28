import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/usecases/add_promo_usecase.dart';
import '../../domain/usecases/update_promo_usecase.dart';
import '../../domain/usecases/upload_promo_image_usecase.dart';
import 'promos_controller.dart';

/// Form controller managing creation and modification of promotional banners.
/// Adheres strictly to Clean Architecture:
/// - Enforces guard clauses against duplicate submissions while loading
/// - Zero raw try-catch blocks (functional error handling via fpdart)
/// - Proper resource disposal
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
      final result = await getProductsUseCase!.call();
      result.fold(
        (failure) {},
        (fetched) {
          _products = fetched;
          notifyListeners();
        },
      );
    }

    if (_brands.isEmpty && brandRepository != null) {
      _isBrandsLoading = true;
      notifyListeners();

      final result = await brandRepository!.getBrands();
      result.fold(
        (failure) {},
        (fetched) {
          _brands = fetched;
        },
      );

      _isBrandsLoading = false;
      notifyListeners();
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

  /// Saves or updates the promotional banner.
  /// Returns `true` if operation succeeded, `false` otherwise.
  Future<bool> savePromo() async {
    // Guard clause against duplicate concurrent submissions
    if (_isLoading) return false;

    if (_existingImageUrl.isEmpty && _selectedImage == null) {
      AppFeedback.showError('يجب اختيار صورة للإعلان');
      return false;
    }

    if (_selectedTargetType == 'product' &&
        (_selectedTargetId == null || _selectedTargetId!.trim().isEmpty)) {
      AppFeedback.showError('يجب اختيار منتج للإعلان');
      return false;
    }

    if (_selectedTargetType == 'brand' &&
        (_selectedTargetId == null || _selectedTargetId!.trim().isEmpty)) {
      AppFeedback.showError('يجب اختيار ماركة للإعلان');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    String finalImageUrl = _existingImageUrl;
    if (_selectedImage != null) {
      final uploadResult = await uploadPromoImageUseCase.call(_selectedImage!.path);
      final bool uploadSucceeded = uploadResult.fold(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (url) {
          finalImageUrl = url;
          return true;
        },
      );
      if (!uploadSucceeded) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    final targetId = _selectedTargetType == 'none' ? null : _selectedTargetId;

    final promoData = PromoEntity(
      id: initialPromo?.id ?? '',
      title: {
        'ar': titleArController.text.trim(),
        'en': titleEnController.text.trim(),
      },
      subtitle: {
        'ar': subtitleArController.text.trim(),
        'en': subtitleEnController.text.trim(),
      },
      buttonText: {
        'ar': buttonArController.text.trim(),
        'en': buttonEnController.text.trim(),
      },
      imageUrl: finalImageUrl,
      backgroundColor: backgroundColorController.text.isNotEmpty
          ? backgroundColorController.text.trim()
          : '#FFFFFF',
      targetType: _selectedTargetType,
      targetId: targetId,
      isActive: _isActive,
      createdAt: initialPromo?.createdAt,
    );

    if (isEditing) {
      final result = await updatePromoUseCase.call(promoData);
      _isLoading = false;
      notifyListeners();
      return result.fold(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (updated) {
          promosController?.updatePromoLocally(updated);
          AppFeedback.showSuccess('تم تحديث الإعلان بنجاح');
          return true;
        },
      );
    } else {
      final result = await addPromoUseCase.call(promoData);
      _isLoading = false;
      notifyListeners();
      return result.fold(
        (failure) {
          AppFeedback.showError(failure.toMessage());
          return false;
        },
        (added) {
          promosController?.updatePromoLocally(added);
          AppFeedback.showSuccess('تمت إضافة الإعلان بنجاح');
          return true;
        },
      );
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
