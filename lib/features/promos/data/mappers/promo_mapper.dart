import '../../domain/entities/promo_entity.dart';
import '../models/promo_model.dart';

/// Extension mapper converting [PromoModel] DTO to domain [PromoEntity].
extension PromoModelMapper on PromoModel {
  PromoEntity toEntity() {
    return PromoEntity(
      id: id,
      title: title != null ? Map<String, dynamic>.from(title!) : null,
      subtitle: subtitle != null ? Map<String, dynamic>.from(subtitle!) : null,
      buttonText: buttonText != null
          ? Map<String, dynamic>.from(buttonText!)
          : null,
      imageUrl: imageUrl,
      backgroundColor: backgroundColor,
      targetType: targetType,
      targetId: targetId,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}

/// Extension mapper converting domain [PromoEntity] to data [PromoModel] DTO.
extension PromoEntityMapper on PromoEntity {
  PromoModel toModel() {
    return PromoModel(
      id: id,
      title: title != null ? Map<String, dynamic>.from(title!) : null,
      subtitle: subtitle != null ? Map<String, dynamic>.from(subtitle!) : null,
      buttonText: buttonText != null
          ? Map<String, dynamic>.from(buttonText!)
          : null,
      imageUrl: imageUrl,
      backgroundColor: backgroundColor,
      targetType: targetType,
      targetId: targetId,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
