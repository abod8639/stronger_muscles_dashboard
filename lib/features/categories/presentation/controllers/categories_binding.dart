import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../data/datasources/category_remote_datasource.dart';
import 'categories_controller.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(dio));

    // Repository
    // Get.lazyPut<CategoryRepository>(() => 
    // CategoryRepositoryImpl(
    //   Get.find<CategoryRemoteDataSource>()
    //   )
    // );

    // Use Cases
    // Get.lazyPut(() => GetCategoriesUseCase(Get.find<CategoryRepository>()));
    // Get.lazyPut(() => AddCategoryUseCase(Get.find<CategoryRepository>()));
    // Get.lazyPut(() => UpdateCategoryUseCase(Get.find<CategoryRepository>()));
    Get.lazyPut(() => DeleteCategoryUseCase(Get.find<CategoryRepository>()));

    // Controller
    Get.put(CategoriesController(
      // getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
      // addCategoryUseCase: Get.find<AddCategoryUseCase>(),
      // updateCategoryUseCase: Get.find<UpdateCategoryUseCase>(),
      // deleteCategoryUseCase: Get.find<DeleteCategoryUseCase>(),
    ));
  }
}
