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

  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;

  String get displayName {
    if (nameAr.isNotEmpty) return nameAr;
    if (nameEn.isNotEmpty) return nameEn;
    return id;
  }
}
