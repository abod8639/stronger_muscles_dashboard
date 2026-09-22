import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/upload_product_image_usecase.dart';
import '../../../../core/network/api/brand_service.dart';
import '../../../brands/domain/repositories/brand_repository.dart';
import '../../../brands/data/repositories/brand_repository_impl.dart';
import 'products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Get.find<ApiBase>().dio;

    // Data Sources
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio), fenix: true);

    // Repositories
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find<ProductRemoteDataSource>()), fenix: true);
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find<ApiService>()), fenix: true);
    }
    
    if (!Get.isRegistered<BrandRepository>()) {
      Get.lazyPut<BrandService>(() => BrandService(), fenix: true);
      Get.lazyPut<BrandRepository>(() => BrandRepositoryImpl(brandService: Get.find<BrandService>()), fenix: true);
    }

    // Use Cases
    Get.lazyPut(() => GetProductsUseCase(Get.find<ProductRepository>()), fenix: true);
    Get.lazyPut(() => AddProductUseCase(Get.find<ProductRepository>()), fenix: true);
    Get.lazyPut(() => UpdateProductUseCase(Get.find<ProductRepository>()), fenix: true);
    Get.lazyPut(() => DeleteProductUseCase(Get.find<ProductRepository>()), fenix: true);
    Get.lazyPut(() => UploadProductImageUseCase(Get.find<ProductRepository>()), fenix: true);

    // Controller
    Get.lazyPut<ProductsController>(() => ProductsController(
      getProductsUseCase: Get.find<GetProductsUseCase>(),
      addProductUseCase: Get.find<AddProductUseCase>(),
      updateProductUseCase: Get.find<UpdateProductUseCase>(),
      deleteProductUseCase: Get.find<DeleteProductUseCase>(),
      uploadProductImageUseCase: Get.find<UploadProductImageUseCase>(),
      categoryRepository: Get.find<CategoryRepository>(),
      brandRepository: Get.find<BrandRepository>(),
    ), fenix: true);
  }
}
