/// Data Transfer Object (DTO) for Settings.
/// Strictly decoupled from Domain Entities with zero entity imports.
class SettingsModel {
  final String storeName;
  final String supportEmail;
  final String supportPhone;
  final String currency;
  final double deliveryFee;
  final double freeDeliveryThreshold;
  final bool isStoreOpen;
  final bool orderNotificationsEnabled;
  final bool maintenanceMode;
  final List<String> allowedAdminRoles;
  final DateTime? updatedAt;

  const SettingsModel({
    required this.storeName,
    required this.supportEmail,
    required this.supportPhone,
    required this.currency,
    required this.deliveryFee,
    required this.freeDeliveryThreshold,
    required this.isStoreOpen,
    required this.orderNotificationsEnabled,
    required this.maintenanceMode,
    required this.allowedAdminRoles,
    this.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      storeName: json['store_name']?.toString() ?? 'Stronger Muscles',
      supportEmail:
          json['support_email']?.toString() ?? 'support@strongermuscles.com',
      supportPhone:
          json['support_phone']?.toString() ?? '+964 770 000 0000',
      currency: json['currency']?.toString() ?? 'IQD',
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 5000.0,
      freeDeliveryThreshold:
          (json['free_delivery_threshold'] as num?)?.toDouble() ?? 100000.0,
      isStoreOpen: json['is_store_open'] == true ||
          json['is_store_open'] == 1 ||
          json['is_store_open'] == null,
      orderNotificationsEnabled:
          json['order_notifications_enabled'] == true ||
              json['order_notifications_enabled'] == 1 ||
              json['order_notifications_enabled'] == null,
      maintenanceMode: json['maintenance_mode'] == true ||
          json['maintenance_mode'] == 1,
      allowedAdminRoles: (json['allowed_admin_roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['admin', 'super_admin'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'support_email': supportEmail,
      'support_phone': supportPhone,
      'currency': currency,
      'delivery_fee': deliveryFee,
      'free_delivery_threshold': freeDeliveryThreshold,
      'is_store_open': isStoreOpen,
      'order_notifications_enabled': orderNotificationsEnabled,
      'maintenance_mode': maintenanceMode,
      'allowed_admin_roles': allowedAdminRoles,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static const SettingsModel defaultSettings = SettingsModel(
    storeName: 'Stronger Muscles',
    supportEmail: 'support@strongermuscles.com',
    supportPhone: '+964 770 000 0000',
    currency: 'IQD',
    deliveryFee: 5000.0,
    freeDeliveryThreshold: 100000.0,
    isStoreOpen: true,
    orderNotificationsEnabled: true,
    maintenanceMode: false,
    allowedAdminRoles: ['admin', 'super_admin'],
  );
}
