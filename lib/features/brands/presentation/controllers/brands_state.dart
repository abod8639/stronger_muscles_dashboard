import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../../domain/entities/brand_entity.dart';

enum BrandsStatus {
  initial,
  loading,
  refreshing,
  success,
  failure,
}

/// Immutable state for the Brands feature.
@immutable
class BrandsState {
  final BrandsStatus status;
  final List<BrandEntity> brands;
  final List<BrandEntity> filteredBrands;
  final String searchQuery;
  final String? selectedBrandId;
  final Failure? failure;

  const BrandsState({
    this.status = BrandsStatus.initial,
    this.brands = const [],
    this.filteredBrands = const [],
    this.searchQuery = '',
    this.selectedBrandId,
    this.failure,
  });

  const BrandsState.initial() : this(status: BrandsStatus.initial);

  bool get isLoading => status == BrandsStatus.loading;
  bool get isRefreshing => status == BrandsStatus.refreshing;
  bool get isSuccess => status == BrandsStatus.success;
  bool get isFailure => status == BrandsStatus.failure;
  bool get isEmpty => isSuccess && filteredBrands.isEmpty;
  String? get errorMessage => failure?.toMessage();

  BrandEntity? get selectedBrand {
    if (selectedBrandId == null) return null;
    try {
      return brands.firstWhere((b) => b.id == selectedBrandId);
    } catch (_) {
      return null;
    }
  }

  BrandsState copyWith({
    BrandsStatus? status,
    List<BrandEntity>? brands,
    List<BrandEntity>? filteredBrands,
    String? searchQuery,
    String? selectedBrandId,
    Failure? failure,
    bool clearSelectedBrand = false,
  }) {
    return BrandsState(
      status: status ?? this.status,
      brands: brands ?? this.brands,
      filteredBrands: filteredBrands ?? this.filteredBrands,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrandId: clearSelectedBrand
          ? null
          : (selectedBrandId ?? this.selectedBrandId),
      failure: failure ?? this.failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandsState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          listEquals(brands, other.brands) &&
          listEquals(filteredBrands, other.filteredBrands) &&
          searchQuery == other.searchQuery &&
          selectedBrandId == other.selectedBrandId &&
          failure == other.failure;

  @override
  int get hashCode =>
      status.hashCode ^
      brands.hashCode ^
      filteredBrands.hashCode ^
      searchQuery.hashCode ^
      selectedBrandId.hashCode ^
      failure.hashCode;
}
