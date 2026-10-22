import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/network/api/brand_service.dart';
import 'package:stronger_muscles_dashboard/features/brands/data/repositories/brand_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';

final brandServiceProvider = Provider<BrandService>((ref) {
  return BrandService();
});

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepositoryImpl(brandService: ref.watch(brandServiceProvider));
});

final brandsListProvider = FutureProvider<List<BrandEntity>>((ref) async {
  final repo = ref.watch(brandRepositoryProvider);
  return await repo.getBrands();
});
