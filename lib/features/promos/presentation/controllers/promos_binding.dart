import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/product_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

class PromosBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Get.isRegistered<ApiBase>() ? Get.find<ApiBase>().dio : Dio();

    // Promo data layer
    Get.lazyPut<PromoRemoteDataSource>(() => PromoRemoteDataSourceImpl(dio: dio));
    Get.lazyPut<PromoRepository>(() => PromoRepositoryImpl(remoteDataSource: Get.find()));

    Get.lazyPut(() => GetPromosUseCase(Get.find()));
    Get.lazyPut(() => AddPromoUseCase(Get.find()));
    Get.lazyPut(() => UpdatePromoUseCase(Get.find()));
    Get.lazyPut(() => DeletePromoUseCase(Get.find()));
    Get.lazyPut(() => UploadPromoImageUseCase(Get.find()));

    // Product data layer (for the product picker dropdown)
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio));
      Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()));
    }
    if (!Get.isRegistered<GetProductsUseCase>()) {
      Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepository>()));
    }

    Get.lazyPut(() => PromosController(
          getPromosUseCase: Get.find(),
          addPromoUseCase: Get.find(),
          updatePromoUseCase: Get.find(),
          deletePromoUseCase: Get.find(),
          getProductsUseCase: Get.find(),
          // uploadPromoImageUseCase: Get.find(),
        ));
  }
}
