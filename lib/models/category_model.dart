import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 13) 
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) String? imageUrl,
    @HiveField(4) @Default(0) int sortOrder,
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) dynamic icon, 
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