import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    @Default(0) int sortOrder,
    @Default(true) bool isActive,
    dynamic icon,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => 
      _$CategoryModelFromJson(_customJson(json));
}

Map<String, dynamic> _customJson(Map<String, dynamic> json) {
  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'name': (json['name'] ?? '').toString(),
    'description': (json['description'] ?? '').toString(),
    'image_url': json['imageUrl'] ?? json['image_url'],
    'sort_order': int.tryParse((json['sortOrder'] ?? json['sort_order'] ?? 0).toString()) ?? 0,
    'is_active': json['isActive'] == true || 
                 json['is_active'] == true || 
                 json['isActive'] == 1 || 
                 json['is_active'] == 1,
  };
}