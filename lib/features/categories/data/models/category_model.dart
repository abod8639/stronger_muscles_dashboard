import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 13)
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required TranslatableString name,
    @HiveField(2) TranslatableString? description,
    @HiveField(3) String? imageUrl,
    @HiveField(4) @Default(0) int sortOrder,
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) dynamic icon,
    @JsonKey(name: 'parentId') @HiveField(7) String? parentId,
    @HiveField(8) @Default([]) List<CategoryModel> children,
  }) = _CategoryModel;

  const CategoryModel._();

  String get displayName {
    if (name.ar.isNotEmpty) return name.ar;
    if (name.en.isNotEmpty) return name.en;
    return id;
  }

  CategoryEntity toEntity() => CategoryEntity(
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
        children: children.map((e) => e.toEntity()).toList(),
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(_customJson(json));
}

Map<String, dynamic> _customJson(Map<String, dynamic> json) {
  if (json['processed'] == true) return json;

  dynamic parseTranslatable(dynamic val) {
    if (val is Map) {
      return {
        'ar': val['ar']?.toString() ?? '',
        'en': val['en']?.toString() ?? '',
      };
    }
    final strVal = val?.toString() ?? '';
    return {'ar': strVal, 'en': strVal};
  }

  return {
    ...json,
    'id': json['id']?.toString() ?? '',
    'name': parseTranslatable(json['name']),
    'description': parseTranslatable(json['description']),
    'imageUrl': json['imageUrl'] ?? json['image_url'],
    'parentId': json['parentId'] ?? json['parent_id'],
    'sortOrder': json['sortOrder'] ?? json['sort_order'] ?? 0,
    'isActive': json['isActive'] ?? json['is_active'] ?? true,
    'processed': true,
  };
}
