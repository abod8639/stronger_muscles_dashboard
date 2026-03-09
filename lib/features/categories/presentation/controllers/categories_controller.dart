import 'package:get/get.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categories_usecase.dart';

class CategoriesController extends GetxController {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesController({required this.getCategoriesUseCase});

  final categories = <CategoryEntity>[].obs;
  final filteredCategories = <CategoryEntity>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final result = await getCategoriesUseCase();
      categories.assignAll(result);
      applySearch();
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applySearch();
  }

  void applySearch() {
    if (searchQuery.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredCategories.assignAll(
        categories.where((c) {
          return c.nameAr.toLowerCase().contains(query) ||
              c.nameEn.toLowerCase().contains(query) ||
              c.id.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
