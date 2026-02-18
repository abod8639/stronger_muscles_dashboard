import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'product_model.dart'; // For TranslatableString

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
  String get displayName => name.ar;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(_customJson(json));
}

Map<String, dynamic> _customJson(Map<String, dynamic> json) {
  dynamic parseTranslatable(dynamic val) {
    if (val is Map) return val;
    return {'ar': val?.toString() ?? '', 'en': ''};
  }

  return {
    ...json,
    'name': parseTranslatable(json['name']),
    'description': parseTranslatable(json['description']),
    'image_url': json['imageUrl'] ?? json['image_url'],
    'parentId': json['parentId'] ?? json['parent_id'],
    'children': json['children'] ?? [],
  };
}
