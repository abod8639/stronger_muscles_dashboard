import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/repositories/promo_repository.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/usecases/promo_usecases.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promos_controller.dart';

class PromosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoRemoteDataSource>(
        () => PromoRemoteDataSourceImpl(dio: Get.put(Dio())));
        
    Get.lazyPut<PromoRepository>(
        () => PromoRepositoryImpl(remoteDataSource: Get.find()));

    Get.lazyPut(() => GetPromosUseCase(Get.find()));
    Get.lazyPut(() => AddPromoUseCase(Get.find()));
    Get.lazyPut(() => UpdatePromoUseCase(Get.find()));
    Get.lazyPut(() => DeletePromoUseCase(Get.find()));

    Get.lazyPut(() => PromosController(
          getPromosUseCase: Get.find(),
          addPromoUseCase: Get.find(),
          updatePromoUseCase: Get.find(),
          deletePromoUseCase: Get.find(),
        ));
  }
}
