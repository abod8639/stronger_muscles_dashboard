import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/config/gemini_config.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/ai_product_suggestion_model.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/ai_product_suggestion_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/ai_product_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/generate_product_suggestion_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/upload_product_image_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';

class MockAiProductRepository implements AiProductRepository {
  @override
  Future<Either<Failure, AiProductSuggestionEntity>> generateProductDetails({
    required String productName,
    List<String>? availableCategories,
    List<String>? availableBrands,
  }) async {
    return const Right(
      AiProductSuggestionEntity(
        nameAr: 'واي بروتين جولد ستاندرد',
        nameEn: 'Gold Standard 100% Whey',
        descAr: 'بروتين نقي عالي الجودة للاستشفاء العضلي',
        descEn: 'High quality whey protein for muscle recovery',
        brandName: 'Optimum Nutrition',
        suggestedCategory: 'بروتينات',
        servingSize: '30g',
        servingsPerContainer: 73,
        calories: '120',
        protein: '24g',
        carbs: '3g',
        fat: '1.5g',
        sugar: '1g',
        allergens: ['حليب', 'صويا'],
        tags: ['واي بروتين', 'استشفاء'],
        flavors: ['شوكولاتة', 'فانيليا'],
        suggestedSizes: [
          {'size': '5 Lbs', 'weight': '2.27kg', 'servings': 73},
        ],
        skuPrefix: 'ON-GSW',
      ),
    );
  }
}

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
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('product AI mixin correctly fetches and applies AI suggestions', () async {
      final aiController = ProductsController(
        addProductUseCase: AddProductUseCase(mockProductRepo),
        updateProductUseCase: UpdateProductUseCase(mockProductRepo),
        deleteProductUseCase: DeleteProductUseCase(mockProductRepo),
        uploadProductImageUseCase: UploadProductImageUseCase(mockProductRepo),
        categoryRepository: MockCategoryRepository(),
        brandRepository: MockBrandRepository(),
        generateProductSuggestionUseCase: GenerateProductSuggestionUseCase(
          MockAiProductRepository(),
        ),
      );

      final suggestion = await aiController.fetchAiSuggestions('Gold Standard');
      expect(suggestion, isNotNull);
      expect(suggestion!.nameAr, 'واي بروتين جولد ستاندرد');
      expect(suggestion.brandName, 'Optimum Nutrition');

      aiController.applyAiSuggestions(suggestion);

      expect(aiController.textcontrollers['name_ar']?.text, 'واي بروتين جولد ستاندرد');
      expect(aiController.textcontrollers['name_en']?.text, 'Gold Standard 100% Whey');
      expect(aiController.textcontrollers['brand']?.text, 'Optimum Nutrition');
      expect(aiController.textcontrollers['calories']?.text, '120');
      expect(aiController.textcontrollers['protein']?.text, '24g');
      expect(aiController.allergens, contains('حليب'));
      expect(aiController.productFlavors, contains('شوكولاتة'));
      expect(aiController.productSizes.any((s) => s.size == '5 Lbs'), isTrue);
      expect(aiController.isFormDirty, isTrue);

      aiController.dispose();
    });
  });

  group('Gemini & AI Models Tests', () {
    test('GeminiConfig returns valid default model and available models list', () {
      expect(GeminiConfig.defaultModel, 'gemini-1.5-flash');
      expect(GeminiConfig.availableModels.length, 3);
      expect(
        GeminiConfig.availableModels.any((m) => m['id'] == 'gemini-1.5-flash'),
        isTrue,
      );
    });

    test('AiProductSuggestionModel safely deserializes JSON and maps to entity', () {
      final json = {
        'name_ar': 'كرياتين مونوهيدرات',
        'name_en': 'Creatine Monohydrate',
        'desc_ar': 'كرياتين نقي لزيادة القوة والحجم العضلي',
        'desc_en': 'Pure creatine for strength and power',
        'brand': 'Dymatize',
        'serving_size': '5g',
        'servings_per_container': 60,
        'nutrition_facts': {
          'calories': '0',
          'protein': '0g',
          'carbs': '0g',
          'fat': '0g',
          'sugar': '0g',
        },
        'allergens': <String>[],
        'tags': ['كرياتين', 'طاقة'],
        'flavors': ['بدون نكهة'],
        'suggested_sizes': [
          {'size': '300g', 'servings': 60},
        ],
        'sku_prefix': 'DYM-CRE',
      };

      final model = AiProductSuggestionModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.nameAr, 'كرياتين مونوهيدرات');
      expect(entity.brandName, 'Dymatize');
      expect(entity.servingsPerContainer, 60);
      expect(entity.tags, contains('كرياتين'));
      expect(entity.skuPrefix, 'DYM-CRE');
    });
  });
}
