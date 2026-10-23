import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/repositories/brand_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BrandRepositoryImpl(dio);
});

final brandsListProvider = FutureProvider.autoDispose<List<BrandEntity>>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel('cancelled by riverpod dispose'));

  final repo = ref.watch(brandRepositoryProvider);
  final result = await repo.getBrands(cancelToken: cancelToken);
  return result.fold(
    (failure) => throw Exception(failure.toMessage()),
    (brands) => brands,
  );
});
