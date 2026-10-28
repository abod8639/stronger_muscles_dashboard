import '../../domain/entities/brand_entity.dart';
import '../models/brand_model.dart';

/// Extension Mappers converting between [BrandModel] (DTO) and [BrandEntity] (Domain).
/// Ensures strict separation of concerns across the data and domain boundaries.
extension BrandModelX on BrandModel {
  BrandEntity toEntity() {
    return BrandEntity(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }
}

extension BrandEntityX on BrandEntity {
  BrandModel toModel() {
    return BrandModel(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }
}

extension BrandModelListX on List<BrandModel> {
  List<BrandEntity> toEntities() {
    return map((model) => model.toEntity()).toList();
  }
}
