import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';
import 'package:stronger_muscles_dashboard/features/brands/domain/repositories/brand_repository.dart';

import '../../../../core/network/api/brand_service.dart';


class BrandRepositoryImpl implements BrandRepository {
  final BrandService brandService;

  BrandRepositoryImpl({required this.brandService});

  @override
  Future<List<BrandEntity>> getBrands() async {
    final data = await brandService.fetchBrands();
    return data.map((json) => _mapToEntity(json)).toList();
  }

  BrandEntity _mapToEntity(Map<String, dynamic> json) {
    return BrandEntity(
      id: json['id']?.toString() ?? '',
      nameAr: json['name_ar'] ?? json['name']?['ar'] ?? '',
      nameEn: json['name_en'] ?? json['name']?['en'] ?? '',
      imageUrl: json['image_url'] ?? json['image'],
      isActive: json['is_active'] ?? true,
    );
  }
}
