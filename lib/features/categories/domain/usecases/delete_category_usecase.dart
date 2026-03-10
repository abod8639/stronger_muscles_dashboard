import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';

import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteCategory(id);
  }
}
