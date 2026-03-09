import 'package:get/get.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import 'products_controller.dart';
import '../../../../data/services/api/api_base.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    // Core (Dio from ApiBase)
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio));

    // Repositories
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()));

    // Use Cases
    Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepository>()));

    // Controller
    Get.put(ProductsController(getProductsUseCase: Get.find<GetProductsUseCase>()));
  }
}
