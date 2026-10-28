import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';

/// Form controller for adding and editing categories.
/// Manages TextEditingControllers, parent selection, active status, and resource disposal.
class CategoriesController extends ChangeNotifier {
  final idController = TextEditingController();
  final nameArController = TextEditingController();
  final nameEnController = TextEditingController();
  final imageController = TextEditingController();
  final descArController = TextEditingController();
  final descEnController = TextEditingController();
  final iconController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  String _parentId = '';
  String get parentId => _parentId;
  set parentId(String val) {
    _parentId = val;
    notifyListeners();
  }

  bool _isActive = true;
  bool get isActive => _isActive;
  set isActive(bool val) {
    _isActive = val;
    notifyListeners();
  }

  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;
  set categories(List<CategoryEntity> val) {
    _categories = val;
    notifyListeners();
  }

  @override
  void dispose() {
    idController.dispose();
    nameArController.dispose();
    nameEnController.dispose();
    imageController.dispose();
    descArController.dispose();
    descEnController.dispose();
    iconController.dispose();
    super.dispose();
  }

  void clearForm() {
    idController.clear();
    nameArController.clear();
    nameEnController.clear();
    imageController.clear();
    descArController.clear();
    descEnController.clear();
    iconController.clear();
    _parentId = '';
    _isActive = true;
    notifyListeners();
  }

  void prepareFormForEdit(CategoryEntity category) {
    idController.text = category.id;
    nameArController.text = category.nameAr;
    nameEnController.text = category.nameEn;
    imageController.text = category.imageUrl ?? '';
    descArController.text = category.descriptionAr ?? '';
    descEnController.text = category.descriptionEn ?? '';
    iconController.text = category.icon?.toString() ?? '';
    _parentId = category.parentId ?? '';
    _isActive = category.isActive;
    notifyListeners();
  }

  Map<String, dynamic> buildFormData() {
    return {
      'id': idController.text.trim(),
      'name': {
        'ar': nameArController.text.trim(),
        'en': nameEnController.text.trim(),
      },
      'image_url': imageController.text.trim(),
      'description': {
        'ar': descArController.text.trim(),
        'en': descEnController.text.trim(),
      },
      'sort_order': 0,
      'is_active': _isActive,
      'parent_id': _parentId.isEmpty ? null : _parentId,
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: idController.text.trim(),
      nameAr: nameArController.text.trim(),
      nameEn: nameEnController.text.trim(),
      imageUrl: imageController.text.trim().isNotEmpty ? imageController.text.trim() : null,
      descriptionAr: descArController.text.trim().isNotEmpty ? descArController.text.trim() : null,
      descriptionEn: descEnController.text.trim().isNotEmpty ? descEnController.text.trim() : null,
      parentId: _parentId.isNotEmpty ? _parentId : null,
      isActive: _isActive,
    );
  }
}
