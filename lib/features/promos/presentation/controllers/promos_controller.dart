import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';

class PromosController extends ChangeNotifier {
  final GetPromosUseCase getPromosUseCase;
  final AddPromoUseCase addPromoUseCase;
  final UpdatePromoUseCase updatePromoUseCase;
  final DeletePromoUseCase deletePromoUseCase;
  final GetProductsUseCase getProductsUseCase;
  final UploadPromoImageUseCase uploadPromoImageUseCase;
  final BrandRepository brandRepository;

  PromosController({
    required this.getPromosUseCase,
    required this.addPromoUseCase,
    required this.updatePromoUseCase,
    required this.deletePromoUseCase,
    required this.getProductsUseCase,
    required this.uploadPromoImageUseCase,
    required this.brandRepository,
  });

  List<PromoEntity> _promos = [];
  List<PromoEntity> get promos => _promos;

  List<PromoEntity> _filteredPromos = [];
  List<PromoEntity> get filteredPromos => _filteredPromos;

  List<ProductEntity> _products = [];
  List<ProductEntity> get products => _products;

  List<BrandEntity> _brands = [];
  List<BrandEntity> get brands => _brands;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isBrandsLoading = false;
  bool get isBrandsLoading => _isBrandsLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Form state — text fields
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

  // Form state — target
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

  // Form state — other
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

  void init() {
    fetchPromos();
    fetchProducts();
    fetchBrands();

    backgroundColorController.addListener(() {
      _backgroundColorHex = backgroundColorController.text;
      notifyListeners();
    });
  }

  String getBrandName(String? id) {
    if (id == null || id.isEmpty) return 'غير محدد';
    try {
      final brand = _brands.firstWhere((b) => b.id == id);
      return brand.displayName;
    } catch (_) {
      return 'ماركة #$id';
    }
  }

  CancelToken? _cancelToken;

  Future<void> fetchPromos() async {
    _cancelToken?.cancel('طلب جديد للإعلانات');
    _cancelToken = CancelToken();

    _isLoading = true;
    notifyListeners();
    try {
      final result = await getPromosUseCase.call(cancelToken: _cancelToken);
      result.fold(
        (failure) {
          AppFeedback.showError(failure.toMessage());
        },
        (data) {
          _promos = data;
          _applyFilters();
        },
      );
    } catch (e) {
      AppFeedback.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    try {
      final result = await getProductsUseCase.call();
      result.fold(
        (failure) {},
        (data) {
          _products = data;
          notifyListeners();
        },
      );
    } catch (_) {}
  }

  Future<void> fetchBrands() async {
    _isBrandsLoading = true;
    notifyListeners();
    try {
      final result = await brandRepository.getBrands();
      result.fold(
        (failure) {
          debugPrint('❌ [PromosController] Error fetching brands: ${failure.toMessage()}');
        },
        (data) {
          _brands = data;
        },
      );
    } catch (e) {
      debugPrint('❌ [PromosController] Error fetching brands: $e');
    } finally {
      _isBrandsLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredPromos = List.from(_promos);
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredPromos = _promos.where((promo) {
        final matchesTitle = promo.displayTitle.toLowerCase().contains(query);
        final matchesSubtitle = promo.displaySubtitle.toLowerCase().contains(query);
        return matchesTitle || matchesSubtitle;
      }).toList();
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

  void clearForm() {
    titleArController.clear();
    titleEnController.clear();
    subtitleArController.clear();
    subtitleEnController.clear();
    buttonArController.clear();
    buttonEnController.clear();
    backgroundColorController.text = '#FFFFFF';
    _backgroundColorHex = '#FFFFFF';
    _selectedTargetType = 'none';
    _selectedTargetId = null;
    _isActive = true;
    _selectedImage = null;
    _existingImageUrl = '';
    notifyListeners();
  }

  void populateForm(PromoEntity promo) {
    titleArController.text = promo.title?['ar']?.toString() ?? '';
    titleEnController.text = promo.title?['en']?.toString() ?? '';
    subtitleArController.text = promo.subtitle?['ar']?.toString() ?? '';
    subtitleEnController.text = promo.subtitle?['en']?.toString() ?? '';
    buttonArController.text = promo.buttonText?['ar']?.toString() ?? '';
    buttonEnController.text = promo.buttonText?['en']?.toString() ?? '';
    backgroundColorController.text = promo.backgroundColor;
    _backgroundColorHex = promo.backgroundColor;

    _selectedTargetType = promo.targetType;
    _selectedTargetId = promo.targetId ?? '';
    _isActive = promo.isActive;
    _existingImageUrl = promo.imageUrl;
    _selectedImage = null;
    notifyListeners();
  }

  void confirmDelete(BuildContext context, String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد أنك تريد حذف الإعلان "$title"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deletePromo(id);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePromo(String id) async {
    try {
      final result = await deletePromoUseCase.call(id);
      result.fold(
        (failure) {
          AppFeedback.showError(failure.toMessage());
        },
        (_) {
          _promos.removeWhere((p) => p.id == id);
          _applyFilters();
          notifyListeners();
          AppFeedback.showSuccess('تم حذف الإعلان بنجاح');
        },
      );
    } catch (e) {
      AppFeedback.showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void updatePromoLocally(PromoEntity promo) {
    final index = _promos.indexWhere((p) => p.id == promo.id);
    if (index != -1) {
      _promos[index] = promo;
    } else {
      _promos.insert(0, promo);
    }
    _applyFilters();
    notifyListeners();
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
