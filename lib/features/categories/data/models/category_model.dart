import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.descriptionAr,
    super.descriptionEn,
    super.imageUrl,
    super.parentId,
    required super.isActive,
    List<CategoryModel>? super.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse translatable strings
    String parseAr(dynamic val) {
      if (val is Map) return val['ar']?.toString() ?? '';
      return val?.toString() ?? '';
    }

    String parseEn(dynamic val) {
      if (val is Map) return val['en']?.toString() ?? '';
      return '';
    }

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      nameAr: parseAr(json['name']),
      nameEn: parseEn(json['name']),
      descriptionAr: parseAr(json['description']),
      descriptionEn: parseEn(json['description']),
      imageUrl: json['image_url']?.toString(),
      parentId: json['parent_id']?.toString(),
      isActive: json['is_active'] ?? true,
      children: (json['children'] as List?)
          ?.map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': {'ar': nameAr, 'en': nameEn},
      'description': {'ar': descriptionAr, 'en': descriptionEn},
      'image_url': imageUrl,
      'parent_id': parentId,
      'is_active': isActive,
    };
  }
}
