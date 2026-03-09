class CategoryEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String? imageUrl;
  final String? parentId;
  final bool isActive;
  final List<CategoryEntity>? children;

  const CategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.imageUrl,
    this.parentId,
    required this.isActive,
    this.children,
  });

  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;
}
