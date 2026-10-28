import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/products/data/mappers/product_mapper.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity & Sub-Entities Tests', () {
    test('ProductEntity value equality and hashCode contract', () {
      const p1 = ProductEntity(
        id: 'p-1',
        nameAr: 'بروتين مصل اللبن',
        nameEn: 'Whey Protein',
        descriptionAr: 'بروتين عالي الجودة',
        descriptionEn: 'High quality whey',
        price: 199.99,
        discountPrice: 179.99,
        imageUrls: ['https://example.com/whey.png'],
        categoryId: 'cat-1',
        stockQuantity: 50,
        brand: 'Optimum Nutrition',
        isActive: true,
        isFeatured: true,
      );

      const p2 = ProductEntity(
        id: 'p-1',
        nameAr: 'بروتين مصل اللبن',
        nameEn: 'Whey Protein',
        descriptionAr: 'بروتين عالي الجودة',
        descriptionEn: 'High quality whey',
        price: 199.99,
        discountPrice: 179.99,
        imageUrls: ['https://example.com/whey.png'],
        categoryId: 'cat-1',
        stockQuantity: 50,
        brand: 'Optimum Nutrition',
        isActive: true,
        isFeatured: true,
      );

      final p3 = p1.copyWith(price: 249.99);

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
      expect(p3.price, 249.99);
      expect(p1.finalPrice, 179.99);
      expect(p1.isInStock, isTrue);
      expect(p1.displayName, 'بروتين مصل اللبن');
      expect(p1.getName('en'), 'Whey Protein');
    });

    test('ProductSizeEntity equality and copyWith', () {
      const s1 = ProductSizeEntity(
        size: '2kg',
        price: 199.0,
        discountPrice: 179.0,
      );
      const s2 = ProductSizeEntity(
        size: '2kg',
        price: 199.0,
        discountPrice: 179.0,
      );
      final s3 = s1.copyWith(price: 220.0);

      expect(s1, equals(s2));
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1, isNot(equals(s3)));
      expect(s3.price, 220.0);
    });

    test('ProductVariantEntity equality and copyWith', () {
      const v1 = ProductVariantEntity(
        id: 'var-1',
        sku: 'SKU-001',
        price: 150.0,
        discountPrice: 130.0,
        effectivePrice: 130.0,
        stockQuantity: 20,
        attributes: {'flavor': 'Chocolate'},
        isActive: true,
      );
      const v2 = ProductVariantEntity(
        id: 'var-1',
        sku: 'SKU-001',
        price: 150.0,
        discountPrice: 130.0,
        effectivePrice: 130.0,
        stockQuantity: 20,
        attributes: {'flavor': 'Chocolate'},
        isActive: true,
      );
      final v3 = v1.copyWith(stockQuantity: 15);

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1, isNot(equals(v3)));
      expect(v3.stockQuantity, 15);
    });
  });

  group('Product Mappers Tests', () {
    test('ProductModel <-> ProductEntity round-trip mapping', () {
      const model = ProductModel(
        id: 'prod-10',
        name: TranslatableString(ar: 'كرياتين', en: 'Creatine'),
        price: 100.0,
        discountPrice: 85.0,
        description: TranslatableString(ar: 'نقي 100%', en: '100% Pure'),
        imageUrls: [
          ProductImage(
            thumbnail: 'https://example.com/thumb.jpg',
            medium: 'https://example.com/med.jpg',
            original: 'https://example.com/orig.jpg',
          ),
        ],
        categoryId: 'cat-creatine',
        stockQuantity: 35,
        brand: 'Dymatize',
        isActive: true,
        featured: true,
        isBackgroundWhite: true,
        servingSize: '5g',
        servingsPerContainer: 60,
        productSizes: [
          ProductSize(size: '300g', price: 100.0, discountPrice: 85.0),
        ],
        flavor: ['Unflavored', 'Fruit Punch'],
        variants: [
          ProductVariantModel(
            id: 'v-10',
            sku: 'SKU-CR-300',
            price: 100.0,
            discountPrice: 85.0,
            effectivePrice: 85.0,
            stockQuantity: 35,
            attributes: {'flavor': 'Unflavored'},
            isActive: true,
          ),
        ],
      );

      final entity = model.toEntity();

      expect(entity.id, 'prod-10');
      expect(entity.nameAr, 'كرياتين');
      expect(entity.nameEn, 'Creatine');
      expect(entity.price, 100.0);
      expect(entity.discountPrice, 85.0);
      expect(entity.categoryId, 'cat-creatine');
      expect(entity.imageUrls, ['https://example.com/orig.jpg']);
      expect(entity.flavors, ['Unflavored', 'Fruit Punch']);
      expect(entity.productSizes?.first.size, '300g');
      expect(entity.variants?.first.sku, 'SKU-CR-300');

      final roundTripModel = entity.toModel();
      expect(roundTripModel.id, entity.id);
      expect(roundTripModel.name.ar, entity.nameAr);
      expect(roundTripModel.price, entity.price);
      expect(roundTripModel.variants.first.sku, 'SKU-CR-300');
    });
  });
}
