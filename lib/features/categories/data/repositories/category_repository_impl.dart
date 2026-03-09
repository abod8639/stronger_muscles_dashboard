import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CategoryEntity>> getCategories({bool tree = false}) async {
    return await remoteDataSource.getCategories(tree: tree);
  }

  @override
  Future<CategoryEntity> addCategory(CategoryEntity category) async {
    final model = CategoryModel(
      id: category.id,
      nameAr: category.nameAr,
      nameEn: category.nameEn,
      descriptionAr: category.descriptionAr,
      descriptionEn: category.descriptionEn,
      imageUrl: category.imageUrl,
      parentId: category.parentId,
      isActive: category.isActive,
    );
    return await remoteDataSource.addCategory(model);
  }

  @override
  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    final model = CategoryModel(
      id: category.id,
      nameAr: category.nameAr,
      nameEn: category.nameEn,
      descriptionAr: category.descriptionAr,
      descriptionEn: category.descriptionEn,
      imageUrl: category.imageUrl,
      parentId: category.parentId,
      isActive: category.isActive,
    );
    return await remoteDataSource.updateCategory(model);
  }

  @override
  Future<bool> deleteCategory(String id) async {
    return await remoteDataSource.deleteCategory(id);
  }
}
