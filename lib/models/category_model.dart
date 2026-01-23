import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 13, adapterName: 'CategoryModelAdapter')
@JsonSerializable()
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) String? description,
    @HiveField(3) @JsonKey(name: 'image_url') String? imageUrl,
    @HiveField(4) @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @HiveField(5) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    
    // ملاحظة: الأيقونات عادة تخزن كـ String أو int في السيرفر
    @HiveField(6) String? iconData, 
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // معالجة البيانات قبل التمرير للمولد لضمان استقرار النوع
    final Map<String, dynamic> data = Map<String, dynamic>.from(json);
    
    // توحيد مسمى sort_order و isActive
    data['sort_order'] = int.tryParse((data['sortOrder'] ?? data['sort_order'] ?? 0).toString()) ?? 0;
    data['is_active'] = data['isActive'] == true || data['is_active'] == true || data['isActive'] == 1 || data['is_active'] == 1;

    return _$CategoryModelFromJson(data);
  }
}