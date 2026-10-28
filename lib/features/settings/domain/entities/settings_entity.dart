/// Pure Dart domain entity representing general store and dashboard configuration.
/// 100% framework-independent with zero imports from Flutter UI, Dio, or Hive.
class SettingsEntity {
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

  const SettingsEntity({
    this.storeName = 'Stronger Muscles',
    this.supportEmail = 'support@strongermuscles.com',
    this.supportPhone = '+964 770 000 0000',
    this.currency = 'IQD',
    this.deliveryFee = 5000.0,
    this.freeDeliveryThreshold = 100000.0,
    this.isStoreOpen = true,
    this.orderNotificationsEnabled = true,
    this.maintenanceMode = false,
    this.allowedAdminRoles = const ['admin', 'super_admin'],
    this.updatedAt,
  });

  SettingsEntity copyWith({
    String? storeName,
    String? supportEmail,
    String? supportPhone,
    String? currency,
    double? deliveryFee,
    double? freeDeliveryThreshold,
    bool? isStoreOpen,
    bool? orderNotificationsEnabled,
    bool? maintenanceMode,
    List<String>? allowedAdminRoles,
    DateTime? updatedAt,
  }) {
    return SettingsEntity(
      storeName: storeName ?? this.storeName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      currency: currency ?? this.currency,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      freeDeliveryThreshold:
          freeDeliveryThreshold ?? this.freeDeliveryThreshold,
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      orderNotificationsEnabled:
          orderNotificationsEnabled ?? this.orderNotificationsEnabled,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      allowedAdminRoles: allowedAdminRoles ?? this.allowedAdminRoles,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsEntity &&
        other.storeName == storeName &&
        other.supportEmail == supportEmail &&
        other.supportPhone == supportPhone &&
        other.currency == currency &&
        other.deliveryFee == deliveryFee &&
        other.freeDeliveryThreshold == freeDeliveryThreshold &&
        other.isStoreOpen == isStoreOpen &&
        other.orderNotificationsEnabled == orderNotificationsEnabled &&
        other.maintenanceMode == maintenanceMode &&
        _listEquals(other.allowedAdminRoles, allowedAdminRoles) &&
        other.updatedAt == updatedAt;
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      storeName,
      supportEmail,
      supportPhone,
      currency,
      deliveryFee,
      freeDeliveryThreshold,
      isStoreOpen,
      orderNotificationsEnabled,
      maintenanceMode,
      Object.hashAll(allowedAdminRoles),
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'SettingsEntity(storeName: $storeName, currency: $currency, isStoreOpen: $isStoreOpen, maintenanceMode: $maintenanceMode)';
  }
}
