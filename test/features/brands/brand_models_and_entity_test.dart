import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/mappers/brand_mapper.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/models/brand_model.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';

void main() {
  group('BrandEntity Tests', () {
    test('value equality and hashCode contract', () {
      const b1 = BrandEntity(
        id: 'brand-1',
        nameAr: 'أوبتيموم',
        nameEn: 'Optimum Nutrition',
        imageUrl: 'https://example.com/on.png',
      );
      const b2 = BrandEntity(
        id: 'brand-1',
        nameAr: 'أوبتيموم',
        nameEn: 'Optimum Nutrition',
        imageUrl: 'https://example.com/on.png',
      );
      const b3 = BrandEntity(
        id: 'brand-2',
        nameAr: 'ديماتايز',
        nameEn: 'Dymatize',
        imageUrl: 'https://example.com/dymatize.png',
      );

      expect(b1, equals(b2));
      expect(b1.hashCode, equals(b2.hashCode));
      expect(b1, isNot(equals(b3)));
    });

    test('displayName returns language-specific name with graceful fallback', () {
      const b = BrandEntity(
        id: '1',
        nameAr: 'شركة الرياضة',
        nameEn: 'Sport Co',
      );

      expect(b.displayName('ar'), 'شركة الرياضة');
      expect(b.displayName('en'), 'Sport Co');
      expect(b.displayName('fr'), 'Sport Co'); // Fallback to English

      const bArOnly = BrandEntity(
        id: '2',
        nameAr: 'عربي فقط',
      );
      expect(bArOnly.displayName('en'), 'عربي فقط'); // Fallback to Arabic
    });

    test('copyWith produces expected updated clone', () {
      const b = BrandEntity(
        id: '1',
        nameAr: 'قديم',
        nameEn: 'Old',
      );
      final updated = b.copyWith(nameEn: 'New Name');

      expect(updated.id, '1');
      expect(updated.nameAr, 'قديم');
      expect(updated.nameEn, 'New Name');
    });
  });

  group('BrandModel & BrandMapper Tests', () {
    test('fromJson deserializes standard backend JSON correctly', () {
      final json = {
        'id': 'b-100',
        'name_ar': 'ماركة عالمية',
        'name_en': 'Global Brand',
        'image': 'https://cdn.example.com/logo.jpg',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-02T00:00:00Z',
      };

      final model = BrandModel.fromJson(json);

      expect(model.id, 'b-100');
      expect(model.nameAr, 'ماركة عالمية');
      expect(model.nameEn, 'Global Brand');
      expect(model.image, 'https://cdn.example.com/logo.jpg');
      expect(model.createdAt, '2026-01-01T00:00:00Z');
      expect(model.updatedAt, '2026-01-02T00:00:00Z');
    });

    test('fromJson handles int IDs and fallback field names safely', () {
      final json = {
        'id': 999,
        'name': 'Fallback Generic Name',
        'logo': 'https://cdn.example.com/logo2.jpg',
      };

      final model = BrandModel.fromJson(json);

      expect(model.id, '999');
      expect(model.nameAr, 'Fallback Generic Name');
      expect(model.nameEn, 'Fallback Generic Name');
      expect(model.image, 'https://cdn.example.com/logo2.jpg');
    });

    test('toJson serializes model back to Map', () {
      const model = BrandModel(
        id: '1',
        nameAr: 'أ',
        nameEn: 'A',
        image: 'img.png',
      );

      final map = model.toJson();
      expect(map['id'], '1');
      expect(map['name_ar'], 'أ');
      expect(map['name_en'], 'A');
      expect(map['image'], 'img.png');
    });

    test('toEntity and toModel map bidirectionally', () {
      const model = BrandModel(
        id: '77',
        nameAr: 'العلامة',
        nameEn: 'Brand',
        image: 'brand.png',
        createdAt: '2026-01-01',
        updatedAt: '2026-01-02',
      );

      final entity = model.toEntity();
      expect(entity.id, '77');
      expect(entity.nameAr, 'العلامة');
      expect(entity.nameEn, 'Brand');
      expect(entity.image, 'brand.png');
      expect(entity.createdAt, '2026-01-01');
      expect(entity.updatedAt, '2026-01-02');

      final backToModel = entity.toModel();
      expect(backToModel.id, entity.id);
      expect(backToModel.nameAr, entity.nameAr);
      expect(backToModel.nameEn, entity.nameEn);
    });

    test('toEntities maps list of models to list of entities', () {
      final models = [
        const BrandModel(id: '1', nameAr: 'أ'),
        const BrandModel(id: '2', nameAr: 'ب'),
      ];

      final entities = models.toEntities();
      expect(entities.length, 2);
      expect(entities[0].id, '1');
      expect(entities[1].id, '2');
    });
  });
}
