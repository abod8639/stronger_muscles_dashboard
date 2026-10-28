import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/usecases/add_promo_usecase.dart';
import '../../domain/usecases/delete_promo_usecase.dart';
import '../../domain/usecases/get_promos_usecase.dart';
import '../../domain/usecases/update_promo_usecase.dart';
import '../../domain/usecases/upload_promo_image_usecase.dart';

/// Presentation state controller for promotional banners list & management.
/// Adheres strictly to Clean Architecture:
/// - Zero raw try-catch blocks (100% functional error handling via fpdart)
/// - Zero direct Dio or database imports
/// - Proper memory management with dispose
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

  void init() {
    fetchPromos();
    fetchProducts();
    fetchBrands();
  }

  String getBrandName(String? id) {
    if (id == null || id.isEmpty) return 'غير محدد';
    final brand = _brands.where((b) => b.id == id).firstOrNull;
    return brand != null ? brand.displayName : 'ماركة #$id';
  }

  Future<void> fetchPromos() async {
    _isLoading = true;
    notifyListeners();

    final result = await getPromosUseCase.call();
    result.fold(
      (failure) {
        AppFeedback.showError(failure.toMessage());
      },
      (data) {
        _promos = data;
        _applyFilters();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final result = await getProductsUseCase.call();
    result.fold(
      (failure) {
        debugPrint('⚠️ [PromosController] Failed to fetch products: ${failure.toMessage()}');
      },
      (data) {
        _products = data;
        notifyListeners();
      },
    );
  }

  Future<void> fetchBrands() async {
    _isBrandsLoading = true;
    notifyListeners();

    final result = await brandRepository.getBrands();
    result.fold(
      (failure) {
        debugPrint('⚠️ [PromosController] Failed to fetch brands: ${failure.toMessage()}');
      },
      (data) {
        _brands = data;
      },
    );

    _isBrandsLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.trim().isEmpty) {
      _filteredPromos = List.from(_promos);
    } else {
      final query = _searchQuery.toLowerCase().trim();
      _filteredPromos = _promos.where((promo) {
        final matchesTitle = promo.displayTitle.toLowerCase().contains(query);
        final matchesSubtitle = promo.displaySubtitle.toLowerCase().contains(query);
        return matchesTitle || matchesSubtitle;
      }).toList();
    }
  }

  Future<bool> deletePromo(String id) async {
    final result = await deletePromoUseCase.call(id);
    return result.fold(
      (failure) {
        AppFeedback.showError(failure.toMessage());
        return false;
      },
      (_) {
        _promos.removeWhere((p) => p.id == id);
        _applyFilters();
        notifyListeners();
        AppFeedback.showSuccess('تم حذف الإعلان بنجاح');
        return true;
      },
    );
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
}
