import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/usecases/get_brand_by_id_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import 'brands_providers.dart';
import 'brands_state.dart';

/// Presentation Controller managing the list, search, and selection of Brands.
/// Strictly functional error handling with ZERO try-catch blocks.
/// 100% testable via Constructor Dependency Injection.
class BrandsNotifier extends Notifier<BrandsState> {
  final GetBrandsUseCase? _injectedGetBrandsUseCase;
  final GetBrandByIdUseCase? _injectedGetBrandByIdUseCase;

  BrandsNotifier({
    GetBrandsUseCase? getBrandsUseCase,
    GetBrandByIdUseCase? getBrandByIdUseCase,
  })  : _injectedGetBrandsUseCase = getBrandsUseCase,
        _injectedGetBrandByIdUseCase = getBrandByIdUseCase;

  GetBrandsUseCase get _getBrandsUseCase =>
      _injectedGetBrandsUseCase ?? ref.read(getBrandsUseCaseProvider);

  GetBrandByIdUseCase get _getBrandByIdUseCase =>
      _injectedGetBrandByIdUseCase ?? ref.read(getBrandByIdUseCaseProvider);

  @override
  BrandsState build() {
    // Automatically trigger initial load on controller registration
    Future.microtask(() => loadBrands());
    return const BrandsState.initial();
  }

  /// Loads brands from repository (cache-first or fresh)
  Future<void> loadBrands({bool forceRefresh = false}) async {
    state = state.copyWith(
      status: forceRefresh ? BrandsStatus.refreshing : BrandsStatus.loading,
    );

    final result = await _getBrandsUseCase(forceRefresh: forceRefresh);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BrandsStatus.failure,
          failure: failure,
        );
      },
      (brandsList) {
        final filtered = _filterBrandsList(brandsList, state.searchQuery);
        state = state.copyWith(
          status: BrandsStatus.success,
          brands: brandsList,
          filteredBrands: filtered,
          failure: null,
        );
      },
    );
  }

  /// Filters brands in-memory based on bilingual query
  void searchBrands(String query) {
    final trimmed = query.trim();
    final filtered = _filterBrandsList(state.brands, trimmed);

    state = state.copyWith(
      searchQuery: trimmed,
      filteredBrands: filtered,
    );
  }

  /// Clears active search filter
  void clearSearch() {
    searchBrands('');
  }

  /// Selects or deselects a brand
  void selectBrand(String? brandId) {
    if (brandId == null) {
      state = state.copyWith(clearSelectedBrand: true);
    } else {
      state = state.copyWith(selectedBrandId: brandId);
    }
  }

  List<BrandEntity> _filterBrandsList(List<BrandEntity> list, String query) {
    if (query.isEmpty) return list;
    final lowerQuery = query.toLowerCase();

    return list.where((brand) {
      final nameArMatch = brand.nameAr.toLowerCase().contains(lowerQuery);
      final nameEnMatch = brand.nameEn.toLowerCase().contains(lowerQuery);
      return nameArMatch || nameEnMatch;
    }).toList();
  }
}
