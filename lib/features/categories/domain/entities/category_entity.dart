class CategoryEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? imageUrl;
  final String? parentId;
  final bool isActive;
  final int sortOrder;
  final dynamic icon;
  final List<CategoryEntity> children;

  const CategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.imageUrl,
    this.parentId,
    required this.isActive,
    this.sortOrder = 0,
    this.icon,
    this.children = const [],
  });

  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;

  String get displayName {
    if (nameAr.isNotEmpty) return nameAr;
    if (nameEn.isNotEmpty) return nameEn;
    return id;
  }
}
