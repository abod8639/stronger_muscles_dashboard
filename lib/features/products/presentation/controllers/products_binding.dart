import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import 'products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Get.find<ApiBase>().dio;

    // Data Sources
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio));

    // Repositories
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()));
    // Note: CategoryRepository still used via ApiService internally in some places, 
    // but here we provide it to the controller.
    Get.lazyPut(() => CategoryRepository(Get.find())); 

    // Use Cases
    Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => AddProductUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => UpdateProductUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => DeleteProductUseCase(Get.find<ProductRepository>()));
    Get.lazyPut(() => UploadProductImageUseCase(Get.find<ProductRepository>()));

    // Controller
    Get.put(ProductsController(
      getProductsUseCase: Get.find<GetProductsUseCase>(),
      addProductUseCase: Get.find<AddProductUseCase>(),
      updateProductUseCase: Get.find<UpdateProductUseCase>(),
      deleteProductUseCase: Get.find<DeleteProductUseCase>(),
      uploadProductImageUseCase: Get.find<UploadProductImageUseCase>(),
      categoryRepository: Get.find<CategoryRepository>(),
    ));
  }
}
