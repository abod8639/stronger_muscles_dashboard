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
  String get displayName {
    if (name.ar.isNotEmpty) return name.ar;
    if (name.en.isNotEmpty) return name.en;
    return id; // Fallback to ID if no name is available
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(_customJson(json));
}

Map<String, dynamic> _customJson(Map<String, dynamic> json) {
  dynamic parseTranslatable(dynamic val) {
    if (val is Map) {
      return {
        'ar': val['ar']?.toString() ?? '',
        'en': val['en']?.toString() ?? '',
      };
    }
    // If it's a string, use it for both or specific logic (here assuming ar)
    final strVal = val?.toString() ?? '';
    return {'ar': strVal, 'en': strVal}; // Use same string for both as fallback
  }

  return {
    ...json,
    'id': json['id']?.toString() ?? '', // Ensure ID is a string
    'name': parseTranslatable(json['name']),
    'description': parseTranslatable(json['description']),
    'image_url': json['imageUrl'] ?? json['image_url'],
    'parentId': json['parentId'] ?? json['parent_id'],
    'children': (json['children'] as List?)?.map((e) => _customJson(e as Map<String, dynamic>)).toList() ?? [], // Recursively parse children
  };
}
