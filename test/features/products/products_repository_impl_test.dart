import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/features/products/data/repositories/product_repository_impl.dart';

class MockProductRemoteDataSource implements ProductRemoteDataSource {
  List<ProductModel>? mockProducts;
  ProductModel? mockProduct;
  Exception? exceptionToThrow;

  @override
  Future<List<ProductModel>> getProducts({CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockProducts ?? [];
  }

  @override
  Future<ProductModel> getProductById(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockProduct!;
  }

  @override
  Future<ProductModel> addProduct(Map<String, dynamic> data, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockProduct!;
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockProduct!;
  }

  @override
  Future<bool> deleteProduct(String id, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return true;
  }

  @override
  Future<String> uploadImage(String filePath, {CancelToken? cancelToken}) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return 'https://example.com/uploaded.png';
  }
}

class MockProductLocalDataSource implements ProductLocalDataSource {
  List<ProductModel> storedProducts = [];
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedProducts;
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedProducts = List.from(products);
    cacheValid = true;
  }

  @override
  Future<ProductModel?> getCachedProductById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    try {
      return storedProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = storedProducts.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      storedProducts[index] = product;
    } else {
      storedProducts.add(product);
    }
  }

  @override
  Future<void> deleteCachedProduct(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedProducts.removeWhere((p) => p.id == id);
  }

  @override
  Future<void> clearCache() async {
    storedProducts.clear();
    cacheValid = false;
  }

  @override
  Future<bool> isCacheValid() async {
    return cacheValid;
  }
}

void main() {
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late ProductRepositoryImpl repository;

  const testProductModel = ProductModel(
    id: 'p-1',
    name: TranslatableString(ar: 'واي بروتين', en: 'Whey Protein'),
    price: 150.0,
    description: TranslatableString(ar: 'وصف', en: 'Desc'),
    imageUrls: [],
    categoryId: 'c-1',
    stockQuantity: 10,
    variants: [],
  );

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('ProductRepositoryImpl.getProducts', () {
    test('returns cached products when cache is valid and forceRefresh is false', () async {
      mockLocalDataSource.storedProducts = [testProductModel];
      mockLocalDataSource.cacheValid = true;

      final result = await repository.getProducts(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (products) {
          expect(products.length, 1);
          expect(products.first.id, 'p-1');
        },
      );
    });

    test('fetches from remote and updates local cache when forceRefresh is true', () async {
      mockRemoteDataSource.mockProducts = [testProductModel];

      final result = await repository.getProducts(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right'),
        (products) {
          expect(products.length, 1);
          expect(products.first.id, 'p-1');
        },
      );
      expect(mockLocalDataSource.storedProducts.length, 1);
    });

    test('falls back to cache when remote fails and cached data exists', () async {
      mockLocalDataSource.storedProducts = [testProductModel];
      mockLocalDataSource.cacheValid = false;
      mockRemoteDataSource.exceptionToThrow = const ServerException(
        message: 'Network offline',
        statusCode: 503,
      );

      final result = await repository.getProducts(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Expected Right fallback'),
        (products) {
          expect(products.length, 1);
          expect(products.first.id, 'p-1');
        },
      );
    });

    test('returns Left(Failure) when remote fails and cache is empty', () async {
      mockLocalDataSource.storedProducts = [];
      mockRemoteDataSource.exceptionToThrow = const ServerException(
        message: 'Server error',
        statusCode: 500,
      );

      final result = await repository.getProducts(forceRefresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (products) => fail('Expected Left failure'),
      );
    });
  });

  group('ProductRepositoryImpl mutations', () {
    test('addProduct creates product remotely and saves to cache', () async {
      mockRemoteDataSource.mockProduct = testProductModel;

      final result = await repository.addProduct({'name': 'New Product'});

      expect(result.isRight(), isTrue);
      expect(mockLocalDataSource.storedProducts.length, 1);
    });

    test('deleteProduct deletes remotely and removes from cache', () async {
      mockLocalDataSource.storedProducts = [testProductModel];

      final result = await repository.deleteProduct('p-1');

      expect(result.isRight(), isTrue);
      expect(mockLocalDataSource.storedProducts.isEmpty, isTrue);
    });
  });
}
