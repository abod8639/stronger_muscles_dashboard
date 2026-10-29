/// Data Transfer Object (DTO) for Brands.
/// Strictly decoupled from Domain Entities with no class inheritance.
class BrandModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;
  final bool isActive;

  const BrandModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.imageUrl,
    this.isActive = true,
  });

  /// Resilient parsing safe against nested bilingual maps, null values, and type discrepancies
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] is Map ? json['name'] as Map : null;

    return BrandModel(
      id: json['id']?.toString() ?? '',
      nameAr:
          json['name_ar']?.toString() ??
          nameMap?['ar']?.toString() ??
          json['name']?.toString() ??
          '',
      nameEn:
          json['name_en']?.toString() ??
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameAr == other.nameAr &&
          nameEn == other.nameEn &&
          imageUrl == other.imageUrl &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      id.hashCode ^
      nameAr.hashCode ^
      nameEn.hashCode ^
      imageUrl.hashCode ^
      isActive.hashCode;
}
