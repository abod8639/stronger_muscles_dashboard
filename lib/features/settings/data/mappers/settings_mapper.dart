import '../../domain/entities/settings_entity.dart';
import '../models/settings_model.dart';

/// Extension mapper converting [SettingsModel] DTO to domain [SettingsEntity].
extension SettingsModelMapper on SettingsModel {
  SettingsEntity toEntity() {
    return SettingsEntity(
      storeName: storeName,
      supportEmail: supportEmail,
      supportPhone: supportPhone,
      currency: currency,
      deliveryFee: deliveryFee,
      freeDeliveryThreshold: freeDeliveryThreshold,
      isStoreOpen: isStoreOpen,
      orderNotificationsEnabled: orderNotificationsEnabled,
      maintenanceMode: maintenanceMode,
      allowedAdminRoles: List.from(allowedAdminRoles),
      updatedAt: updatedAt,
    );
  }
}

/// Extension mapper converting domain [SettingsEntity] to data [SettingsModel] DTO.
extension SettingsEntityMapper on SettingsEntity {
  SettingsModel toModel() {
    return SettingsModel(
      storeName: storeName,
      supportEmail: supportEmail,
      supportPhone: supportPhone,
      currency: currency,
      deliveryFee: deliveryFee,
      freeDeliveryThreshold: freeDeliveryThreshold,
      isStoreOpen: isStoreOpen,
      orderNotificationsEnabled: orderNotificationsEnabled,
      maintenanceMode: maintenanceMode,
      allowedAdminRoles: List.from(allowedAdminRoles),
      updatedAt: updatedAt,
    );
  }
}
