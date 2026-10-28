import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/datasources/brand_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/datasources/brand_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/models/brand_model.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/repositories/brand_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';

class MockBrandRemoteDataSource implements BrandRemoteDataSource {
  List<BrandModel>? mockBrands;
  BrandModel? mockBrand;
  Exception? exceptionToThrow;

  @override
  Future<List<BrandModel>> getBrands() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockBrands!;
  }

  @override
  Future<BrandModel> getBrandById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockBrand!;
  }
}

class MockBrandLocalDataSource implements BrandLocalDataSource {
  List<BrandModel> storedBrands = [];
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<List<BrandModel>> getCachedBrands() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedBrands;
  }

  @override
  Future<void> cacheBrands(List<BrandModel> brands) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedBrands = List.from(brands);
    cacheValid = true;
  }

  @override
  Future<BrandModel?> getCachedBrandById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    try {
      return storedBrands.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheBrand(BrandModel brand) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = storedBrands.indexWhere((b) => b.id == brand.id);
    if (index >= 0) {
      storedBrands[index] = brand;
    } else {
      storedBrands.add(brand);
    }
  }

  @override
  Future<bool> isCacheValid() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cacheValid && storedBrands.isNotEmpty;
  }

  @override
  Future<void> clearCache() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedBrands.clear();
    cacheValid = false;
  }
}

void main() {
  late MockBrandRemoteDataSource remoteDataSource;
  late MockBrandLocalDataSource localDataSource;
  late BrandRepositoryImpl repository;

  final tBrandModel = const BrandModel(
    id: 'b-1',
    nameAr: 'ماركة 1',
    nameEn: 'Brand 1',
    image: 'https://example.com/b1.png',
  );

  setUp(() {
    remoteDataSource = MockBrandRemoteDataSource();
    localDataSource = MockBrandLocalDataSource();
    repository = BrandRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  group('BrandRepositoryImpl.getBrands', () {
    test('returns cached brands if cache is valid and forceRefresh is false', () async {
      localDataSource.storedBrands = [tBrandModel];
      localDataSource.cacheValid = true;

      final result = await repository.getBrands(forceRefresh: false);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (brands) {
          expect(brands.length, 1);
          expect(brands.first.id, 'b-1');
        },
      );
    });

    test('fetches from remote, updates cache, and returns Right(List<BrandEntity>) on success', () async {
      remoteDataSource.mockBrands = [tBrandModel];

      final result = await repository.getBrands(forceRefresh: true);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (brands) {
          expect(brands.length, 1);
          expect(brands.first.id, 'b-1');
        },
      );
      expect(localDataSource.storedBrands.length, 1);
    });

    test('falls back to cache if remote throws ServerException but local cache has data', () async {
      localDataSource.storedBrands = [tBrandModel];
      localDataSource.cacheValid = false; // Even if expired, fallback should serve it
      remoteDataSource.exceptionToThrow = const ServerException(message: 'Internal Error');

      final result = await repository.getBrands(forceRefresh: true);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (brands) {
          expect(brands.length, 1);
          expect(brands.first.id, 'b-1');
        },
      );
    });

    test('returns Left(Failure) when remote throws and local cache is empty', () async {
      localDataSource.storedBrands = [];
      remoteDataSource.exceptionToThrow = const ServerException(message: 'Server Down', statusCode: 500);

      final result = await repository.getBrands(forceRefresh: true);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server Down');
        },
        (r) => fail('Should not return right'),
      );
    });
  });

  group('BrandRepositoryImpl.getBrandById', () {
    test('returns brand from local cache when present', () async {
      localDataSource.storedBrands = [tBrandModel];

      final result = await repository.getBrandById('b-1');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (brand) {
          expect(brand.id, 'b-1');
          expect(brand.nameEn, 'Brand 1');
        },
      );
    });

    test('fetches from remote and caches it when not present locally', () async {
      localDataSource.storedBrands = [];
      remoteDataSource.mockBrand = tBrandModel;

      final result = await repository.getBrandById('b-1');

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return left'),
        (brand) {
          expect(brand.id, 'b-1');
        },
      );
      expect(localDataSource.storedBrands.length, 1);
    });

    test('returns Left(Failure) when remote fetch fails', () async {
      localDataSource.storedBrands = [];
      remoteDataSource.exceptionToThrow = const NetworkException(message: 'No internet');

      final result = await repository.getBrandById('b-999');

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
        },
        (r) => fail('Should not return right'),
      );
    });
  });
}
