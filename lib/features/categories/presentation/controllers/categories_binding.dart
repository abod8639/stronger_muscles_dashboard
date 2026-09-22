import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import 'categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    if (!Get.isRegistered<CategoryRepository>()) {
      Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find<ApiService>()), fenix: true);
    }

    // Use Cases
    Get.lazyPut(() => GetCategoriesUseCase(Get.find<CategoryRepository>()), fenix: true);
    Get.lazyPut(() => AddCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);
    Get.lazyPut(() => UpdateCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);
    Get.lazyPut(() => DeleteCategoryUseCase(Get.find<CategoryRepository>()), fenix: true);

    // Controller
    Get.lazyPut<CategoriesController>(() => CategoriesController(
      getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
      addCategoryUseCase: Get.find<AddCategoryUseCase>(),
      updateCategoryUseCase: Get.find<UpdateCategoryUseCase>(),
      deleteCategoryUseCase: Get.find<DeleteCategoryUseCase>(),
    ), fenix: true);
  }
}
