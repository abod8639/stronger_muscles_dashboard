import 'package:stronger_muscles_dashboard/features/brands/domain/entities/brand_entity.dart';

abstract class BrandRepository {
  Future<List<BrandEntity>> getBrands();
}
