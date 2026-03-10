import 'package:get/get.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../data/datasources/product_remote_datasource.dart';
import 'products_controller.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    // Core (Dio from ApiBase)
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio));

    // Repositories
    // Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()));

    // Use Cases
    Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => AddProductUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => UpdateProductUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => DeleteProductUseCase(Get.find<ProductRepository>()));

    // Controller
    Get.put(ProductsController(
      // getProductsUseCase: Get.find<GetProductsUseCase>(),
      // addProductUseCase: Get.find<AddProductUseCase>(),
      // updateProductUseCase: Get.find<UpdateProductUseCase>(),
      // deleteProductUseCase: Get.find<DeleteProductUseCase>(),
    ));
  }
}
