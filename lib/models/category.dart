class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int sortOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'])?.toString(),
      sortOrder: int.tryParse((json['sortOrder'] ?? json['sort_order'] ?? 0).toString()) ?? 0,
      isActive: json['isActive'] == true || json['is_active'] == true ||
                json['isActive'] == 1 || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}