import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.imageUrl,
    super.isActive = true,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] is Map ? json['name'] as Map : null;
    return BrandModel(
      id: json['id']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ??
          nameMap?['ar']?.toString() ??
          json['name']?.toString() ??
          '',
      nameEn: json['name_en']?.toString() ??
          nameMap?['en']?.toString() ??
          json['name']?.toString() ??
          '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active'] == 1 || json['is_active'] == '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}

/// Compute isolate parsing for brand list
List<BrandModel> parseBrandListCompute(dynamic data) {
  if (data is List) {
    return data
        .map((item) => BrandModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
  return [];
}
