/// Pure Dart Domain Entity representing a Category in the e-commerce catalog.
/// 100% pure Dart: zero imports from Flutter UI, Dio, Hive, or 3rd-party SDKs.
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
    this.isActive = true,
    this.sortOrder = 0,
    this.icon,
    this.children = const [],
  });

  /// Returns localized category name based on language code ('ar' / 'en').
  String getName(String lang) => lang == 'ar' ? nameAr : nameEn;

  /// Returns localized display name with graceful fallback.
  String get displayName {
    if (nameAr.isNotEmpty) return nameAr;
    if (nameEn.isNotEmpty) return nameEn;
    return id;
  }

  /// Returns true if this category has child categories.
  bool get hasChildren => children.isNotEmpty;

  CategoryEntity copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? imageUrl,
    String? parentId,
    bool? isActive,
    int? sortOrder,
    dynamic icon,
    List<CategoryEntity>? children,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      imageUrl: imageUrl ?? this.imageUrl,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      icon: icon ?? this.icon,
      children: children ?? this.children,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.id == id &&
        other.nameAr == nameAr &&
        other.nameEn == nameEn &&
        other.descriptionAr == descriptionAr &&
        other.descriptionEn == descriptionEn &&
        other.imageUrl == imageUrl &&
        other.parentId == parentId &&
        other.isActive == isActive &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameAr,
    nameEn,
    descriptionAr,
    descriptionEn,
    imageUrl,
    parentId,
    isActive,
    sortOrder,
  );

  @override
  String toString() =>
      'CategoryEntity(id: $id, nameAr: $nameAr, nameEn: $nameEn, children: ${children.length})';
}
