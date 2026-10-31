import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import '../../data/datasources/promo_local_datasource.dart';
import '../../data/datasources/promo_remote_datasource.dart';
import '../../data/repositories/promo_repository_impl.dart';
import '../../domain/entities/promo_entity.dart';
import '../../domain/repositories/promo_repository.dart';
import '../../domain/usecases/add_promo_usecase.dart';
import '../../domain/usecases/delete_promo_usecase.dart';
import '../../domain/usecases/get_promos_usecase.dart';
import '../../domain/usecases/update_promo_usecase.dart';
import '../../domain/usecases/upload_promo_image_usecase.dart';
import 'promo_form_controller.dart';
import 'promos_controller.dart';

// ==========================================
// Local & Remote Data Source Providers
// ==========================================

/// Hive Box provider for local promos cache
final promosBoxProvider = Provider<Box>((ref) {
  return Hive.box('promos_cache');
});

/// Local Data Source provider
final promoLocalDataSourceProvider = Provider<PromoLocalDataSource>((ref) {
  final box = ref.watch(promosBoxProvider);
  return PromoLocalDataSourceImpl(box: box);
});

/// Remote Data Source provider
final promoRemoteDataSourceProvider = Provider<PromoRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PromoRemoteDataSourceImpl(dio: dio);
});

// ==========================================
// Repository Provider (Single Source of Truth)
// ==========================================

/// Repository provider
final promoRepositoryProvider = Provider<PromoRepository>((ref) {
  final remoteDataSource = ref.watch(promoRemoteDataSourceProvider);
  final localDataSource = ref.watch(promoLocalDataSourceProvider);
  return PromoRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ==========================================
// UseCase Providers
// ==========================================

final getPromosUseCaseProvider = Provider<GetPromosUseCase>((ref) {
  return GetPromosUseCase(ref.watch(promoRepositoryProvider));
});

final addPromoUseCaseProvider = Provider<AddPromoUseCase>((ref) {
  return AddPromoUseCase(ref.watch(promoRepositoryProvider));
});

final updatePromoUseCaseProvider = Provider<UpdatePromoUseCase>((ref) {
  return UpdatePromoUseCase(ref.watch(promoRepositoryProvider));
});

final deletePromoUseCaseProvider = Provider<DeletePromoUseCase>((ref) {
  return DeletePromoUseCase(ref.watch(promoRepositoryProvider));
});

final uploadPromoImageUseCaseProvider = Provider<UploadPromoImageUseCase>((
  ref,
) {
  return UploadPromoImageUseCase(ref.watch(promoRepositoryProvider));
});

// ==========================================
// Presentation Controller Providers
// ==========================================

/// Main Promos list controller provider
final promosControllerProvider = Provider<PromosController>((ref) {
  final controller = PromosController(
    getPromosUseCase: ref.watch(getPromosUseCaseProvider),
    addPromoUseCase: ref.watch(addPromoUseCaseProvider),
    updatePromoUseCase: ref.watch(updatePromoUseCaseProvider),
    deletePromoUseCase: ref.watch(deletePromoUseCaseProvider),
    getProductsUseCase: ref.watch(getProductsUseCaseProvider),
    uploadPromoImageUseCase: ref.watch(uploadPromoImageUseCaseProvider),
    brandRepository: ref.watch(brandRepositoryProvider),
  );
  controller.init();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Promo Form controller provider (autoDispose family)
final promoFormControllerProvider = Provider.autoDispose
    .family<PromoFormController, PromoEntity?>((ref, initialPromo) {
      final controller = PromoFormController(
        initialPromo: initialPromo,
        addPromoUseCase: ref.watch(addPromoUseCaseProvider),
        updatePromoUseCase: ref.watch(updatePromoUseCaseProvider),
        uploadPromoImageUseCase: ref.watch(uploadPromoImageUseCaseProvider),
        getProductsUseCase: ref.watch(getProductsUseCaseProvider),
        brandRepository: ref.watch(brandRepositoryProvider),
        promosController: ref.read(promosControllerProvider),
      );
      controller.init();
      ref.onDispose(controller.dispose);
      return controller;
    });
