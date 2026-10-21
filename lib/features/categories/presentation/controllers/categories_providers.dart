import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';
import 'categories_controller.dart';

/// موفر مصدر بيانات التصنيفات البعيد
final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRemoteDataSourceImpl(dio);
});

/// موفر مستودع التصنيفات
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفرات حالات الاستخدام (UseCases)
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final addCategoryUseCaseProvider = Provider<AddCategoryUseCase>((ref) {
  return AddCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategoryUseCase>((ref) {
  return UpdateCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  return DeleteCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

/// موفر حالة البحث عبر Notifier متوافق مع كافة إصدارات Riverpod
class CategoriesSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final categoriesSearchQueryProvider =
    NotifierProvider<CategoriesSearchQueryNotifier, String>(
  CategoriesSearchQueryNotifier.new,
);

/// موفر تحكم حالة التصنيفات الرئيسي عبر [AsyncNotifier]
final categoriesControllerProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<CategoryEntity>>(
  CategoriesNotifier.new,
);

/// موفر التصنيفات المفلترة تلقائياً عند تغير البحث أو قائمة التصنيفات
final filteredCategoriesProvider = Provider<List<CategoryEntity>>((ref) {
  final categoriesAsync = ref.watch(categoriesControllerProvider);
  final query = ref.watch(categoriesSearchQueryProvider).toLowerCase().trim();

  return categoriesAsync.maybeWhen(
    data: (categories) {
      if (query.isEmpty) return categories;
      return categories.where((c) {
        return c.nameAr.toLowerCase().contains(query) ||
            c.nameEn.toLowerCase().contains(query) ||
            c.id.toLowerCase().contains(query);
      }).toList();
    },
    orElse: () => const [],
  );
});
