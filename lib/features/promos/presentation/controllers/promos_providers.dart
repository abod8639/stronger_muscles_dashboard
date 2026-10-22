import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/brands/presentation/controllers/brands_providers.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_providers.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'promo_form_controller.dart';
import 'promos_controller.dart';

// ==========================================
// Data & Domain Providers
// ==========================================

/// موفر مصدر بيانات الإعلانات الترويجية البعيد
final promoRemoteDataSourceProvider = Provider<PromoRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PromoRemoteDataSourceImpl(dio: dio);
});

/// موفر مستودع الإعلانات
final promoRepositoryProvider = Provider<PromoRepository>((ref) {
  final remoteDataSource = ref.watch(promoRemoteDataSourceProvider);
  return PromoRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفرات حالات الاستخدام
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

final uploadPromoImageUseCaseProvider = Provider<UploadPromoImageUseCase>((ref) {
  return UploadPromoImageUseCase(ref.watch(promoRepositoryProvider));
});

// ==========================================
// Presentation Controllers
// ==========================================

/// موفر متحكم الإعلانات الرئيسي
final promosControllerProvider = ChangeNotifierProvider<PromosController>((ref) {
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
  return controller;
});

/// موفر متحكم نموذج إنشاء/تعديل الإعلان
final promoFormControllerProvider = ChangeNotifierProvider.autoDispose.family<PromoFormController, PromoEntity?>((ref, initialPromo) {
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
  return controller;
});
