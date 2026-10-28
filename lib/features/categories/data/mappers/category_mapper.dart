import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';

/// Extension Mappers to convert between [CategoryModel] (DTO) and pure [CategoryEntity].
extension CategoryModelMapper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      nameAr: name.ar,
      nameEn: name.en,
      descriptionAr: description?.ar,
      descriptionEn: description?.en,
      imageUrl: imageUrl,
      parentId: parentId,
      isActive: isActive,
      sortOrder: sortOrder,
      icon: icon,
      children: children.map((child) => child.toEntity()).toList(),
    );
  }
}

extension CategoryEntityMapper on CategoryEntity {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: TranslatableString(ar: nameAr, en: nameEn),
      description: (descriptionAr != null || descriptionEn != null)
          ? TranslatableString(ar: descriptionAr ?? '', en: descriptionEn ?? '')
          : null,
      imageUrl: imageUrl,
      sortOrder: sortOrder,
      isActive: isActive,
      icon: icon,
      parentId: parentId,
      children: children.map((child) => child.toModel()).toList(),
    );
  }

  /// Maps [CategoryEntity] to the backend JSON format for create/update requests.
  Map<String, dynamic> toRemoteJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': {
        'ar': nameAr,
        'en': nameEn,
      },
      'description': {
        'ar': descriptionAr ?? '',
        'en': descriptionEn ?? '',
      },
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
      'parent_id': parentId?.isNotEmpty == true ? parentId : null,
      if (icon != null) 'icon': icon,
    };
  }
}

extension CategoryModelListMapper on List<CategoryModel> {
  List<CategoryEntity> toEntities() => map((m) => m.toEntity()).toList();
}

extension CategoryEntityListMapper on List<CategoryEntity> {
  List<CategoryModel> toModels() => map((e) => e.toModel()).toList();
}
