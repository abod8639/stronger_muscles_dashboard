/// 100% Pure Dart Domain Entity representing a Brand.
/// Free of any framework, networking, or database library dependencies.
class BrandEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? imageUrl;
  final bool isActive;

  const BrandEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.imageUrl,
    this.isActive = true,
  });

  /// Localized display name based on language code
  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;

  /// Default safe display name (falls back to available language or ID)
  String get displayName {
    if (nameAr.isNotEmpty) return nameAr;
    if (nameEn.isNotEmpty) return nameEn;
    return id;
  }

  BrandEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? imageUrl,
    bool? isActive,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandEntity &&
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

  @override
  String toString() =>
      'BrandEntity(id: $id, nameAr: $nameAr, nameEn: $nameEn, isActive: $isActive)';
}
