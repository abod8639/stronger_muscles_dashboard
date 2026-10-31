import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import '../../data/datasources/brand_local_datasource.dart';
import '../../data/datasources/brand_remote_datasource.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../domain/usecases/create_brand_usecase.dart';
import '../../domain/usecases/get_brand_by_id_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import 'brands_notifier.dart';
import 'brands_state.dart';

/// ============================================================================
/// DATA LAYER PROVIDERS
/// ============================================================================

/// Provider for Hive cache box dedicated to brands
final brandsBoxProvider = Provider<Box>((ref) {
  if (Hive.isBoxOpen('brands')) {
    return Hive.box('brands');
  }
  return Hive.box('brands');
});

/// Provider for Local DataSource
final brandLocalDataSourceProvider = Provider<BrandLocalDataSource>((ref) {
  final box = ref.watch(brandsBoxProvider);
  return BrandLocalDataSourceImpl(box: box);
});

/// Provider for Remote DataSource
final brandRemoteDataSourceProvider = Provider<BrandRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return BrandRemoteDataSourceImpl(dio: dio);
});

/// Provider for BrandRepository (Single Source of Truth)
final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepositoryImpl(
    remoteDataSource: ref.watch(brandRemoteDataSourceProvider),
    localDataSource: ref.watch(brandLocalDataSourceProvider),
  );
});

/// ============================================================================
/// DOMAIN LAYER PROVIDERS (UseCases)
/// ============================================================================

final getBrandsUseCaseProvider = Provider<GetBrandsUseCase>((ref) {
  return GetBrandsUseCase(ref.watch(brandRepositoryProvider));
});

final getBrandByIdUseCaseProvider = Provider<GetBrandByIdUseCase>((ref) {
  return GetBrandByIdUseCase(ref.watch(brandRepositoryProvider));
});

final createBrandUseCaseProvider = Provider<CreateBrandUseCase>((ref) {
  return CreateBrandUseCase(ref.watch(brandRepositoryProvider));
});

/// ============================================================================
/// PRESENTATION LAYER PROVIDERS
/// ============================================================================

/// State management controller for Brands
final brandsNotifierProvider = NotifierProvider<BrandsNotifier, BrandsState>(
  BrandsNotifier.new,
);

/// Backward-compatible provider for consumers relying on FutureProvider
final brandsListProvider = FutureProvider.autoDispose<List<BrandEntity>>((
  ref,
) async {
  final useCase = ref.watch(getBrandsUseCaseProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw Exception(failure.toMessage()),
    (brands) => brands,
  );
});
