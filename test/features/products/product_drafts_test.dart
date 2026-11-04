import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/product_draft_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_draft_model.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/product_draft_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_draft_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_draft_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/add_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_draft_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/delete_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/get_product_drafts_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/save_product_draft_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/update_product_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/usecases/upload_product_image_usecase.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'product_helpers_and_controller_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductDraftModel & Entity Serialization Tests', () {
    test('roundtrip entity <-> model <-> json preserves all fields', () {
      final now = DateTime(2026, 11, 4, 10, 30);
      final draft = ProductDraftEntity(
        id: 'draft_101',
        title: 'واي بروتين جولد ستاندرد',
        updatedAt: now,
        existingProductId: 'prod_99',
        categoryId: 'cat_protein',
        formFields: {
          'name_ar': 'واي بروتين جولد ستاندرد',
          'name_en': 'Gold Standard Whey',
          'price': '150.0',
          'discount': '135.0',
          'brand': 'Optimum Nutrition',
          'manufacturer_url': 'https://example.com/whey',
        },
        imageUrls: ['https://example.com/img1.png'],
        productSizes: const [
          ProductSizeEntity(
            size: '2.27kg',
            price: 150.0,
            discountPrice: 135.0,
            servings: 73,
            weight: '2.27kg',
            stockQuantity: 20,
            flavors: ['Chocolate'],
          ),
        ],
        sizeControllerValues: {
          '2.27kg': {
            'price': '150.0',
            'discount': '135.0',
            'servings': '73',
            'weight': '2.27kg',
            'stock': '20',
          },
        },
        variants: const [
          ProductVariantEntity(
            id: 'v_1',
            sku: 'ON-GSW-2.27',
            price: 150.0,
            effectivePrice: 135.0,
            stockQuantity: 20,
            attributes: {'flavor': 'Chocolate'},
            isActive: true,
          ),
        ],
        productFlavors: const ['Chocolate'],
        tags: const ['واي بروتين', 'استشفاء'],
        allergens: const ['حليب'],
        isActive: true,
        isFeatured: true,
        newArrival: true,
        bestSeller: false,
        isBackgroundWhite: true,
      );

      final model = ProductDraftModel.fromEntity(draft);
      final json = model.toJson();
      final fromJsonModel = ProductDraftModel.fromJson(json);
      final roundtripEntity = fromJsonModel.toEntity();

      expect(roundtripEntity.id, 'draft_101');
      expect(roundtripEntity.title, 'واي بروتين جولد ستاندرد');
      expect(roundtripEntity.existingProductId, 'prod_99');
      expect(roundtripEntity.categoryId, 'cat_protein');
      expect(roundtripEntity.formFields['name_ar'], 'واي بروتين جولد ستاندرد');
      expect(roundtripEntity.formFields['manufacturer_url'], 'https://example.com/whey');
      expect(roundtripEntity.imageUrls, ['https://example.com/img1.png']);
      expect(roundtripEntity.productSizes.length, 1);
      expect(roundtripEntity.productSizes.first.size, '2.27kg');
      expect(roundtripEntity.productSizes.first.servings, 73);
      expect(roundtripEntity.sizeControllerValues['2.27kg']?['price'], '150.0');
      expect(roundtripEntity.variants.first.sku, 'ON-GSW-2.27');
      expect(roundtripEntity.productFlavors, ['Chocolate']);
      expect(roundtripEntity.tags, contains('واي بروتين'));
      expect(roundtripEntity.allergens, contains('حليب'));
      expect(roundtripEntity.isFeatured, isTrue);
      expect(roundtripEntity.newArrival, isTrue);
    });
  });

  group('ProductDraftLocalDataSource & Repository Tests', () {
    late ProductDraftLocalDataSource localDataSource;
    late ProductDraftRepository repository;

    setUp(() async {
      await GetStorage.init();
      localDataSource = ProductDraftLocalDataSourceImpl();
      await localDataSource.clearAllDrafts();
      repository = ProductDraftRepositoryImpl(localDataSource);
    });

    test('saveDraft, getDrafts, deleteDraft, and clearAllDrafts full flow', () async {
      final draft1 = ProductDraftEntity(
        id: 'draft_1',
        title: 'مسودة 1',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        formFields: {'name_ar': 'منتج 1'},
      );

      final draft2 = ProductDraftEntity(
        id: 'draft_2',
        title: 'مسودة 2',
        updatedAt: DateTime.now(),
        formFields: {'name_ar': 'منتج 2'},
      );

      // Save drafts
      final save1Result = await repository.saveDraft(draft1);
      expect(save1Result.isRight(), isTrue);

      final save2Result = await repository.saveDraft(draft2);
      expect(save2Result.isRight(), isTrue);

      // Retrieve drafts (should be ordered newest first)
      final getResult = await repository.getDrafts();
      expect(getResult.isRight(), isTrue);
      getResult.fold(
        (f) => fail('Should not fail'),
        (list) {
          expect(list.length, 2);
          expect(list.first.id, 'draft_2'); // newest
          expect(list.last.id, 'draft_1');
        },
      );

      // Delete draft 1
      final deleteResult = await repository.deleteDraft('draft_1');
      expect(deleteResult.isRight(), isTrue);

      final afterDelete = await repository.getDrafts();
      afterDelete.fold(
        (f) => fail('Should not fail'),
        (list) {
          expect(list.length, 1);
          expect(list.first.id, 'draft_2');
        },
      );

      // Clear all
      await repository.clearAllDrafts();
      final afterClear = await repository.getDrafts();
      afterClear.fold(
        (f) => fail('Should not fail'),
        (list) => expect(list.isEmpty, isTrue),
      );
    });
  });

  group('ProductDraftMixin Controller Integration Tests', () {
    late ProductsController controller;
    late ProductDraftRepository draftRepo;

    setUp(() async {
      await GetStorage.init();
      final localDataSource = ProductDraftLocalDataSourceImpl();
      await localDataSource.clearAllDrafts();
      draftRepo = ProductDraftRepositoryImpl(localDataSource);

      final mockProductRepo = MockProductRepository();
      controller = ProductsController(
        addProductUseCase: AddProductUseCase(mockProductRepo),
        updateProductUseCase: UpdateProductUseCase(mockProductRepo),
        deleteProductUseCase: DeleteProductUseCase(mockProductRepo),
        uploadProductImageUseCase: UploadProductImageUseCase(mockProductRepo),
        categoryRepository: MockCategoryRepository(),
        brandRepository: MockBrandRepository(),
        getProductDraftsUseCase: GetProductDraftsUseCase(draftRepo),
        saveProductDraftUseCase: SaveProductDraftUseCase(draftRepo),
        deleteProductDraftUseCase: DeleteProductDraftUseCase(draftRepo),
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('saveCurrentFormAsDraft captures state and restoreDraft restores it accurately', () async {
      // 1. Fill partial form state
      controller.textcontrollers['name_ar']?.text = 'كرياتين مونوهيدرات';
      controller.textcontrollers['price']?.text = '45.0';
      controller.textcontrollers['brand']?.text = 'Muscletech';
      controller.textcontrollers['manufacturer_url']?.text = 'https://muscletech.com/creatine';
      controller.setFormCategoryId('cat_creatine');
      controller.imageUrls.add('https://example.com/creatine.jpg');
      controller.addProductSize('300g', 45.0, null, weight: '300g', stockQuantity: 50);
      controller.addTag('قوة');
      controller.toggleAllergen('لا يوجد');
      controller.isFeatured = true;

      // 2. Save as draft
      final savedDraft = await controller.saveCurrentFormAsDraft();
      expect(savedDraft, isNotNull);
      expect(savedDraft!.title, 'كرياتين مونوهيدرات');
      expect(controller.activeDraftId, savedDraft.id);
      expect(controller.drafts.length, 1);
      expect(controller.isFormDirty, isFalse);

      // 3. Clear form completely
      controller.clearForm();
      expect(controller.textcontrollers['name_ar']?.text, isEmpty);
      expect(controller.textcontrollers['price']?.text, isEmpty);
      expect(controller.imageUrls, isEmpty);
      expect(controller.productSizes, isEmpty);
      expect(controller.activeDraftId, isNull);

      // 4. Restore draft
      controller.restoreDraft(savedDraft);

      expect(controller.activeDraftId, savedDraft.id);
      expect(controller.textcontrollers['name_ar']?.text, 'كرياتين مونوهيدرات');
      expect(controller.textcontrollers['price']?.text, '45.0');
      expect(controller.textcontrollers['brand']?.text, 'Muscletech');
      expect(controller.textcontrollers['manufacturer_url']?.text, 'https://muscletech.com/creatine');
      expect(controller.formCategoryId, 'cat_creatine');
      expect(controller.imageUrls, ['https://example.com/creatine.jpg']);
      expect(controller.productSizes.length, 1);
      expect(controller.productSizes.first.size, '300g');
      expect(controller.sizePriceControllers['300g']?.text, '45.0');
      expect(controller.tags, contains('قوة'));
      expect(controller.allergens, contains('لا يوجد'));
      expect(controller.isFeatured, isTrue);
      expect(controller.isFormDirty, isTrue);

      // 5. Remove draft
      final deleted = await controller.removeDraft(savedDraft.id);
      expect(deleted, isTrue);
      expect(controller.drafts, isEmpty);
      expect(controller.activeDraftId, isNull);
    });
  });
}
