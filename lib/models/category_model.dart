import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';

// تأكد من أن المسار صحيح لملفات الـ generated
part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(0) @JsonKey(name: 'sort_order') int sortOrder,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    // ملاحظة: الـ Icon عادة لا يتم تحويله لـ JSON بسهولة إلا إذا كان String (path) 
    // أو قمت بعمل Custom Converter له.
    @JsonKey(includeFromJson: false, includeToJson: false) dynamic icon,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => 
      _$CategoryModelFromJson(_customJson(json));
}

/// دالة لمعالجة الاختلافات في مسميات الـ Keys (Mapping) كما كنت تفعل في الـ factory القديم
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