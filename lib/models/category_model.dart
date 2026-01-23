import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 13) // تأكد من استخدام رقم فريد لكل موديل
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) @JsonKey(name: 'image_url') String? imageUrl,
    @HiveField(4) @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @HiveField(5) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @HiveField(6) dynamic icon, // يفضل أن يكون String (اسم الأيقونة) أو int (رقمها)
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => 
      _$CategoryModelFromJson(_customJson(json));
}

// دالة المعالجة اليدوية لضمان توافق الأسماء والأنواع
Map<String, dynamic> _customJson(Map<String, dynamic> json) {
  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'name': (json['name'] ?? '').toString(),
    'description': (json['description'] ?? '').toString(),
    // توحيد مسميات الحقول لتطابق الـ JsonKey المذكور في الأعلى
    'image_url': json['imageUrl'] ?? json['image_url'],
    'sort_order': int.tryParse((json['sortOrder'] ?? json['sort_order'] ?? 0).toString()) ?? 0,
    'is_active': json['isActive'] == true || 
                 json['is_active'] == true || 
                 json['isActive'] == 1 || 
                 json['is_active'] == 1,
  };
}