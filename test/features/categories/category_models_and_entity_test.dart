import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/mappers/category_mapper.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';

void main() {
  group('CategoryEntity Tests', () {
    test('value equality and hashCode contract', () {
      const c1 = CategoryEntity(
        id: 'cat-1',
        nameAr: 'بروتينات',
        nameEn: 'Proteins',
        imageUrl: 'https://example.com/protein.png',
        isActive: true,
      );
      const c2 = CategoryEntity(
        id: 'cat-1',
        nameAr: 'بروتينات',
        nameEn: 'Proteins',
        imageUrl: 'https://example.com/protein.png',
        isActive: true,
      );
      const c3 = CategoryEntity(
        id: 'cat-2',
        nameAr: 'فيتامينات',
        nameEn: 'Vitamins',
      );

      expect(c1, equals(c2));
      expect(c1.hashCode, equals(c2.hashCode));
      expect(c1, isNot(equals(c3)));
    });

    test('displayName returns localized name with graceful fallback', () {
      const cBoth = CategoryEntity(
        id: '1',
        nameAr: 'أحماض أمينية',
        nameEn: 'Amino Acids',
      );
      expect(cBoth.displayName, 'أحماض أمينية');
      expect(cBoth.getName('en'), 'Amino Acids');
      expect(cBoth.getName('ar'), 'أحماض أمينية');

      const cEnOnly = CategoryEntity(
        id: '2',
        nameAr: '',
        nameEn: 'Creatine',
      );
      expect(cEnOnly.displayName, 'Creatine');
    });

    test('copyWith returns modified copy without mutating original', () {
      const original = CategoryEntity(
        id: '1',
        nameAr: 'قديم',
        nameEn: 'Old',
        sortOrder: 1,
      );
      final updated = original.copyWith(nameEn: 'New', sortOrder: 5);

      expect(updated.id, '1');
      expect(updated.nameAr, 'قديم');
      expect(updated.nameEn, 'New');
      expect(updated.sortOrder, 5);
      expect(original.nameEn, 'Old');
    });
  });

  group('CategoryModel & CategoryMapper Tests', () {
    test('fromJson deserializes standard backend JSON safely', () {
      final json = {
        'id': 'cat-100',
        'name': {'ar': 'طاقة', 'en': 'Energy'},
        'description': {'ar': 'مشروبات طاقة', 'en': 'Energy drinks'},
        'imageUrl': 'https://example.com/energy.png',
        'sortOrder': 2,
        'isActive': true,
        'children': [],
      };

      final model = CategoryModel.fromJson(json);

      expect(model.id, 'cat-100');
      expect(model.name.ar, 'طاقة');
      expect(model.name.en, 'Energy');
      expect(model.description?.ar, 'مشروبات طاقة');
      expect(model.imageUrl, 'https://example.com/energy.png');
      expect(model.sortOrder, 2);
      expect(model.isActive, true);
    });

    test('fromJson handles fallback string names and snake_case keys', () {
      final json = {
        'id': 555,
        'name': 'Simple Name',
        'image_url': 'https://example.com/simple.png',
        'sort_order': '3',
        'is_active': 1,
      };

      final model = CategoryModel.fromJson(json);

      expect(model.id, '555');
      expect(model.name.ar, 'Simple Name');
      expect(model.name.en, 'Simple Name');
      expect(model.imageUrl, 'https://example.com/simple.png');
      expect(model.sortOrder, 3);
      expect(model.isActive, true);
    });

    test('toEntity and toModel map bidirectionally', () {
      const model = CategoryModel(
        id: 'cat-77',
        name: TranslatableString(ar: 'سناك', en: 'Snacks'),
        imageUrl: 'https://example.com/snack.png',
        isActive: true,
      );

      final entity = model.toEntity();
      expect(entity.id, 'cat-77');
      expect(entity.nameAr, 'سناك');
      expect(entity.nameEn, 'Snacks');
      expect(entity.imageUrl, 'https://example.com/snack.png');

      final backToModel = entity.toModel();
      expect(backToModel.id, entity.id);
      expect(backToModel.name.ar, entity.nameAr);
      expect(backToModel.name.en, entity.nameEn);
    });

    test('toRemoteJson formats entity correctly for backend API payloads', () {
      const entity = CategoryEntity(
        id: 'cat-88',
        nameAr: 'فيتامين سي',
        nameEn: 'Vitamin C',
        descriptionAr: 'مكمل غذائي',
        descriptionEn: 'Supplement',
        imageUrl: 'https://example.com/c.png',
        parentId: 'cat-vitamins',
        isActive: true,
        sortOrder: 1,
      );

      final json = entity.toRemoteJson();

      expect(json['id'], 'cat-88');
      expect(json['name']['ar'], 'فيتامين سي');
      expect(json['name']['en'], 'Vitamin C');
      expect(json['description']['ar'], 'مكمل غذائي');
      expect(json['image_url'], 'https://example.com/c.png');
      expect(json['parent_id'], 'cat-vitamins');
      expect(json['is_active'], true);
    });
  });
}
