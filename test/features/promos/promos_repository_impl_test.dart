import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/models/promo_model.dart';
import 'package:stronger_muscles_dashboard/features/promos/data/repositories/promo_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';

class MockPromoRemoteDataSource implements PromoRemoteDataSource {
  List<PromoModel>? mockPromos;
  PromoModel? mockPromo;
  String? mockUploadedUrl;
  Exception? exceptionToThrow;

  @override
  Future<List<PromoModel>> getPromos() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockPromos ?? [];
  }

  @override
  Future<PromoModel> addPromo(Map<String, dynamic> promoData) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockPromo!;
  }

  @override
  Future<PromoModel> updatePromo(String id, Map<String, dynamic> promoData) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockPromo!;
  }

  @override
  Future<void> deletePromo(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  @override
  Future<String> uploadImage(String filePath) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return mockUploadedUrl ?? 'https://example.com/uploaded.png';
  }
}

class MockPromoLocalDataSource implements PromoLocalDataSource {
  List<PromoModel> storedPromos = [];
  bool cacheValid = false;
  Exception? exceptionToThrow;

  @override
  Future<List<PromoModel>> getCachedPromos() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedPromos;
  }

  @override
  Future<void> cachePromos(List<PromoModel> promos) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedPromos = List.from(promos);
  }

  @override
  Future<PromoModel?> getCachedPromoById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return storedPromos.where((p) => p.id == id).firstOrNull;
  }

  @override
  Future<void> cachePromo(PromoModel promo) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final index = storedPromos.indexWhere((p) => p.id == promo.id);
    if (index != -1) {
      storedPromos[index] = promo;
    } else {
      storedPromos.insert(0, promo);
    }
  }

  @override
  Future<void> deleteCachedPromo(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    storedPromos.removeWhere((p) => p.id == id);
  }

  @override
  Future<bool> isCacheValid() async {
    return cacheValid;
  }

  @override
  Future<void> clearCache() async {
    storedPromos.clear();
  }
}

void main() {
  late MockPromoRemoteDataSource mockRemote;
  late MockPromoLocalDataSource mockLocal;
  late PromoRepositoryImpl repository;

  final testPromoModel = PromoModel(
    id: 'pr-1',
    title: const {'ar': 'عرض البداية', 'en': 'Starting Offer'},
    imageUrl: 'https://example.com/p1.jpg',
    backgroundColor: '#FFFFFF',
    targetType: 'none',
    isActive: true,
  );

  setUp(() {
    mockRemote = MockPromoRemoteDataSource();
    mockLocal = MockPromoLocalDataSource();
    repository = PromoRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('PromoRepositoryImpl.getPromos', () {
    test('fetches from remote, updates Hive cache, and returns Right(List<PromoEntity>)', () async {
      mockRemote.mockPromos = [testPromoModel];

      final result = await repository.getPromos();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, 1);
          expect(entities.first.id, 'pr-1');
          expect(entities.first.displayTitle, 'عرض البداية');
        },
      );
      expect(mockLocal.storedPromos.length, 1);
    });

    test('falls back to local cache when remote fails if local cache has data', () async {
      mockRemote.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/promos'),
        error: 'No internet connection',
        type: DioExceptionType.connectionError,
      );
      mockLocal.storedPromos = [testPromoModel];

      final result = await repository.getPromos();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right from cache fallback'),
        (entities) {
          expect(entities.length, 1);
          expect(entities.first.id, 'pr-1');
        },
      );
    });

    test('returns Left(Failure) when remote fails and local cache is empty', () async {
      mockRemote.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/promos'),
        error: 'Server unavailable',
        type: DioExceptionType.badResponse,
      );
      mockLocal.storedPromos = [];

      final result = await repository.getPromos();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<Failure>());
        },
        (_) => fail('Expected Left'),
      );
    });
  });

  group('PromoRepositoryImpl Mutations', () {
    const testEntity = PromoEntity(
      id: 'pr-new',
      title: {'ar': 'جديد', 'en': 'New'},
      imageUrl: 'https://example.com/new.png',
      backgroundColor: '#111111',
      targetType: 'none',
      isActive: true,
    );

    test('addPromo sends to remote, caches locally, and returns Right(PromoEntity)', () async {
      final addedModel = PromoModel(
        id: 'pr-new',
        title: const {'ar': 'جديد', 'en': 'New'},
        imageUrl: 'https://example.com/new.png',
        backgroundColor: '#111111',
        targetType: 'none',
        isActive: true,
      );
      mockRemote.mockPromo = addedModel;

      final result = await repository.addPromo(testEntity);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.id, 'pr-new');
        },
      );
      expect(mockLocal.storedPromos.any((p) => p.id == 'pr-new'), isTrue);
    });

    test('updatePromo updates remote, updates cache, and returns Right(PromoEntity)', () async {
      final updatedModel = PromoModel(
        id: 'pr-new',
        title: const {'ar': 'محدث', 'en': 'Updated'},
        imageUrl: 'https://example.com/new.png',
        backgroundColor: '#111111',
        targetType: 'none',
        isActive: true,
      );
      mockRemote.mockPromo = updatedModel;

      final result = await repository.updatePromo(testEntity);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.displayTitle, 'محدث');
        },
      );
      expect(mockLocal.storedPromos.first.title?['ar'], 'محدث');
    });

    test('deletePromo removes from remote and local cache, returning Right(unit)', () async {
      mockLocal.storedPromos = [testPromoModel];

      final result = await repository.deletePromo('pr-1');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (u) {
          expect(u, equals(unit));
        },
      );
      expect(mockLocal.storedPromos.isEmpty, isTrue);
    });

    test('uploadImage returns public URL on success', () async {
      mockRemote.mockUploadedUrl = 'https://cdn.example.com/promo.jpg';

      final result = await repository.uploadImage('/tmp/img.jpg');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (url) {
          expect(url, 'https://cdn.example.com/promo.jpg');
        },
      );
    });
  });
}
