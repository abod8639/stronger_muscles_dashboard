import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
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
      _$CategoryModelFromJson(_safeCategoryJson(json));

  /// معالجة استخراج تصنيف مفرد في Isolate منفصل عبر `compute` لمنع تجميد واجهة المستخدم
  static Future<CategoryModel> fromJsonAsync(Map<String, dynamic> json) async {
    return await compute(_parseCategoryIsolate, json);
  }

  /// معالجة استخراج قائمة تصنيفات كاملة (أو شجرة التصنيفات) في Isolate خلفي
  static Future<List<CategoryModel>> fromJsonListAsync(
    List<dynamic> jsonList,
  ) async {
    return await compute(_parseCategoryListIsolate, jsonList);
  }
}

/// دوال Isolate Top-level
CategoryModel _parseCategoryIsolate(Map<String, dynamic> json) {
  return CategoryModel.fromJson(json);
}

List<CategoryModel> _parseCategoryListIsolate(List<dynamic> jsonList) {
  final list = <CategoryModel>[];
  for (final item in jsonList) {
    if (item is Map) {
      try {
        list.add(CategoryModel.fromJson(Map<String, dynamic>.from(item)));
      } catch (e) {
        debugPrint('X Error parsing category in Isolate: $e');
      }
    }
  }
  return list;
}

/// تحليل آمن ومقاوم للـ TypeError والـ Null Pointer في جميع الحقول
Map<String, dynamic> _safeCategoryJson(Map<String, dynamic> json) {
  if (json['processed'] == true) return json;

  dynamic parseTranslatable(dynamic val) {
    if (val is Map) {
      return {
        'ar': val['ar']?.toString().trim() ?? '',
        'en': val['en']?.toString().trim() ?? '',
      };
    }
    final strVal = val?.toString().trim() ?? '';
    return {'ar': strVal, 'en': strVal};
  }

  int parseSortOrder(dynamic val) {
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 0;
    if (val is num) return val.toInt();
    return 0;
  }

  bool parseIsActive(dynamic val) {
    if (val is bool) return val;
    if (val is int || val is num) return val == 1;
    if (val is String) {
      final lower = val.toLowerCase().trim();
      return lower == '1' || lower == 'true' || lower == 'active';
    }
    return true;
  }

  List<dynamic> parseChildren(dynamic val) {
    if (val is List) {
      return val
          .whereType<Map>()
          .map((item) => _safeCategoryJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }

  return {
    ...json,
    'id': json['id']?.toString().trim() ?? '',
    'name': parseTranslatable(json['name']),
    'description': parseTranslatable(json['description']),
    'imageUrl': json['imageUrl']?.toString() ?? json['image_url']?.toString(),
    'parentId': json['parentId']?.toString() ?? json['parent_id']?.toString(),
    'sortOrder': parseSortOrder(json['sortOrder'] ?? json['sort_order']),
    'isActive': parseIsActive(json['isActive'] ?? json['is_active']),
    'children': parseChildren(json['children']),
    'processed': true,
  };
}
