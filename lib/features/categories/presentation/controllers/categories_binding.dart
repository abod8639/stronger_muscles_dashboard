import 'package:get/get.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import 'categories_controller.dart';
import '../../../../data/services/api/api_base.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;

    // Data Sources
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(dio));

    // Repository
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find<CategoryRemoteDataSource>()));

    // Use Case
    Get.lazyPut(() => GetCategoriesUseCase(Get.find<CategoryRepository>()));

    // Controller
    Get.put(CategoriesController(getCategoriesUseCase: Get.find<GetCategoriesUseCase>()));
  }
}
