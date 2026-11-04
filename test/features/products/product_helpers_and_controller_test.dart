import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/upload_product_image_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';

class MockCategoryRepository implements CategoryRepository {
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockBrandRepository implements BrandRepository {
  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands({
    bool forceRefresh = false,
  }) async => const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockProductRepository implements ProductRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ProductSkuGenerator Tests', () {
    test('slugify standardizes ASCII text into uppercase hyphenated slug', () {
      expect(ProductSkuGenerator.slugify('Whey Gold 100%'), 'WHEY-GOLD-100');
    });

    test('slugify maps Arabic flavor terms to standardized tokens', () {
      expect(ProductSkuGenerator.slugify('شوكولاتة بالحليب'), 'CHOCO');
      expect(ProductSkuGenerator.slugify('فانيليا مركزة'), 'VANILLA');
      expect(ProductSkuGenerator.slugify('فراولة طازجة'), 'STRAWBERRY');
      expect(ProductSkuGenerator.slugify('بدون نكهة'), 'UNFLAVORED');
    });

    test('generateMatrix builds Cartesian combinations from sizes and flavors', () {
      final sizes = [
        const ProductSizeEntity(
          size: '2kg',
          price: 150.0,
          discountPrice: 130.0,
          stockQuantity: 10,
        ),
      ];
      final flavors = ['شوكولاتة', 'فانيليا'];

      final matrix = ProductSkuGenerator.generateMatrix(
        rawBaseSku: 'WHEY-100',
        basePrice: 150.0,
        baseDiscount: 130.0,
        sizes: sizes,
        globalFlavors: flavors,
        resolveSizePrice: (size, fallback) => fallback,
        resolveSizeDiscount: (size, fallback) => fallback,
        resolveSizeStock: (size, fallback) => fallback ?? 0,
      );

      expect(matrix.length, 2);
      expect(matrix.first.sku, contains('WHEY-100-2KG-CHOCO'));
      expect(matrix.first.effectivePrice, 130.0);
      expect(matrix.first.attributes['size'], '2kg');
      expect(matrix.first.attributes['flavor'], 'شوكولاتة');
    });
  });

  group('ProductFormPayloadBuilder Tests', () {
    test('builds payload prioritizing variant stock over basic stock', () {
      final nameArCtrl = TextEditingController(text: 'منتج تجريبي');
      final stockCtrl = TextEditingController(text: '50');
      final textControllers = {
        'name_ar': nameArCtrl,
        'stock': stockCtrl,
      };

      final List<ProductVariantEntity> variants = [
        const ProductVariantEntity(
          id: 'v1',
          sku: 'SKU1',
          price: 100,
          effectivePrice: 100,
          stockQuantity: 15,
          attributes: {},
          isActive: true,
        ),
        const ProductVariantEntity(
          id: 'v2',
          sku: 'SKU2',
          price: 100,
          effectivePrice: 100,
          stockQuantity: 25,
          attributes: {},
          isActive: true,
        ),
      ];

      final payload = ProductFormPayloadBuilder.build(
        existingProduct: null,
        categoryId: 'cat-1',
        productImages: ['https://example.com/img.png'],
        textControllers: textControllers,
        productSizes: const [],
        sizePriceControllers: const {},
        sizeDiscountControllers: const {},
        sizeServingsControllers: const {},
        sizeWeightControllers: const {},
        sizeStockControllers: const {},
        variants: variants,
        productFlavors: const [],
        tags: const [],
        allergens: const [],
        isActive: true,
        isFeatured: false,
        newArrival: false,
        bestSeller: false,
        isBackgroundWhite: false,
      );

      expect(payload['stock_quantity'], 40); // 15 + 25 = 40
      expect(payload['category_id'], 'cat-1');
      expect(payload['name']['ar'], 'منتج تجريبي');
      expect(payload['name']['en'], 'منتج تجريبي'); // Fallback to Arabic name
    });
  });

  group('ProductsController Modularity Tests', () {
    late ProductsController controller;
    late MockProductRepository mockProductRepo;

    setUp(() {
      mockProductRepo = MockProductRepository();
      controller = ProductsController(
        addProductUseCase: AddProductUseCase(mockProductRepo),
        updateProductUseCase: UpdateProductUseCase(mockProductRepo),
        deleteProductUseCase: DeleteProductUseCase(mockProductRepo),
        uploadProductImageUseCase: UploadProductImageUseCase(mockProductRepo),
        categoryRepository: MockCategoryRepository(),
        brandRepository: MockBrandRepository(),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('selection mixin toggles items and bulk modes correctly', () {
      expect(controller.isSelectionMode, isFalse);
      expect(controller.selectedCount, 0);

      controller.toggleProductSelection('prod-1');
      expect(controller.isSelectionMode, isTrue);
      expect(controller.isProductSelected('prod-1'), isTrue);
      expect(controller.selectedCount, 1);

      controller.deselectAll();
      expect(controller.isSelectionMode, isFalse);
      expect(controller.selectedCount, 0);
    });

    test('form fields mixin manages tags, allergens, and clearForm properly', () {
      controller.addTag('جديد');
      controller.addTag('بروتين');
      expect(controller.tags, ['جديد', 'بروتين']);

      controller.toggleAllergen('حليب');
      expect(controller.allergens, ['حليب']);

      controller.clearForm();
      expect(controller.tags, isEmpty);
      expect(controller.allergens, isEmpty);
      expect(controller.isFormDirty, isFalse);
    });
  });
}
