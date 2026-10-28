import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';

class MockCategoryRemoteDataSource implements CategoryRemoteDataSource {
  List<CategoryModel>? mockCategories;
  CategoryModel? mockCategory;
  Exception? exceptionToThrow;

  @override
  Future<List<CategoryModel>> getCategories({bool tree = false, CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockCategories!;
  }

  @override
  Future<CategoryModel> getCategoryById(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockCategory!;
  }

  @override
  Future<CategoryModel> addCategory(Map<String, dynamic> categoryData, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockCategory!;
  }

  @override
  Future<CategoryModel> updateCategory(String id, Map<String, dynamic> categoryData, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockCategory!;
  }

  @override
  Future<bool> deleteCategory(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return true;
  }
}

class MockCategoryLocalDataSource implements CategoryLocalDataSource {
  List<CategoryModel> storedCategories = [];
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<List<CategoryModel>> getCachedCategories({bool tree = false}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedCategories;
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories, {bool tree = false}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedCategories = List.from(categories);
    cacheValid = true;
  }

  @override
  Future<CategoryModel?> getCachedCategoryById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    try {
      return storedCategories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheCategory(CategoryModel category) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = storedCategories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      storedCategories[index] = category;
    } else {
      storedCategories.add(category);
    }
  }

  @override
  Future<void> deleteCachedCategory(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedCategories.removeWhere((c) => c.id == id);
  }

  @override
  Future<bool> isCacheValid({bool tree = false}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cacheValid && storedCategories.isNotEmpty;
  }

  @override
  Future<void> clearCache() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedCategories.clear();
    cacheValid = false;
  }
}

void main() {
  late MockCategoryRemoteDataSource remoteDataSource;
  late MockCategoryLocalDataSource localDataSource;
  late CategoryRepositoryImpl repository;

  const tCategoryModel = CategoryModel(
    id: 'cat-1',
    name: TranslatableString(ar: 'بروتينات', en: 'Proteins'),
    imageUrl: 'https://example.com/protein.png',
    isActive: true,
  );

  const tCategoryEntity = CategoryEntity(
    id: 'cat-1',
    nameAr: 'بروتينات',
    nameEn: 'Proteins',
    imageUrl: 'https://example.com/protein.png',
    isActive: true,
  );

  setUp(() {
    remoteDataSource = MockCategoryRemoteDataSource();
    localDataSource = MockCategoryLocalDataSource();
    repository = CategoryRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('CategoryRepositoryImpl.getCategories', () {
    test('returns cached categories when cache is valid and forceRefresh is false', () async {
      localDataSource.storedCategories = [tCategoryModel];
      localDataSource.cacheValid = true;

      final result = await repository.getCategories(forceRefresh: false);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right'),
        (categories) {
          expect(categories.length, 1);
          expect(categories.first.id, 'cat-1');
        },
      );
    });

    test('fetches from remote, updates cache, and returns Right(List<CategoryEntity>) on success', () async {
      remoteDataSource.mockCategories = [tCategoryModel];

      final result = await repository.getCategories(forceRefresh: true);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right'),
        (categories) {
          expect(categories.length, 1);
          expect(categories.first.id, 'cat-1');
        },
      );
      expect(localDataSource.storedCategories.length, 1);
    });

    test('falls back to cache if remote throws ServerException and local cache has data', () async {
      localDataSource.storedCategories = [tCategoryModel];
      remoteDataSource.exceptionToThrow = const ServerException(message: 'Server Down');

      final result = await repository.getCategories(forceRefresh: true);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right'),
        (categories) {
          expect(categories.first.id, 'cat-1');
        },
      );
    });

    test('returns Left(Failure) when remote throws and local cache is empty', () async {
      localDataSource.storedCategories = [];
      remoteDataSource.exceptionToThrow = const ServerException(message: 'Server Down', statusCode: 500);

      final result = await repository.getCategories(forceRefresh: true);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server Down');
        },
        (r) => fail('Expected left'),
      );
    });
  });

  group('CategoryRepositoryImpl.addCategory & deleteCategory', () {
    test('addCategory calls remote, caches new category, and returns Right(CategoryEntity)', () async {
      remoteDataSource.mockCategory = tCategoryModel;

      final result = await repository.addCategory(tCategoryEntity);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected right'),
        (cat) => expect(cat.id, 'cat-1'),
      );
      expect(localDataSource.storedCategories.length, 1);
    });

    test('deleteCategory calls remote and removes from cache', () async {
      localDataSource.storedCategories = [tCategoryModel];

      final result = await repository.deleteCategory('cat-1');

      expect(result.isRight(), true);
      expect(localDataSource.storedCategories.isEmpty, true);
    });
  });
}
