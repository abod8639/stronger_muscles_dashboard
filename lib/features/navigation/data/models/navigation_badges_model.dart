/// Data Transfer Object (DTO) for Navigation item badges.
/// Strictly decoupled from Domain Entities with no class inheritance.
class NavigationBadgesModel {
  final int pendingOrdersCount;
  final int unreadNotificationsCount;
  final int openTicketsCount;
  final int lowStockProductsCount;

  const NavigationBadgesModel({
    this.pendingOrdersCount = 0,
    this.unreadNotificationsCount = 0,
    this.openTicketsCount = 0,
    this.lowStockProductsCount = 0,
  });

  factory NavigationBadgesModel.fromJson(Map<String, dynamic> json) {
    return NavigationBadgesModel(
      pendingOrdersCount: _safeInt(
        json['pending_orders'] ??
            json['pendingOrdersCount'] ??
            json['pending_orders_count'],
      ),
      unreadNotificationsCount: _safeInt(
        json['unread_notifications'] ??
            json['unreadNotificationsCount'] ??
            json['unread_notifications_count'],
      ),
      openTicketsCount: _safeInt(
        json['open_tickets'] ??
            json['openTicketsCount'] ??
            json['open_tickets_count'],
      ),
      lowStockProductsCount: _safeInt(
        json['low_stock_products'] ??
            json['lowStockProductsCount'] ??
            json['low_stock_products_count'],
      ),
    );
  }

  static int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() => {
    'pending_orders': pendingOrdersCount,
    'unread_notifications': unreadNotificationsCount,
    'open_tickets': openTicketsCount,
    'low_stock_products': lowStockProductsCount,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationBadgesModel &&
          runtimeType == other.runtimeType &&
          pendingOrdersCount == other.pendingOrdersCount &&
          unreadNotificationsCount == other.unreadNotificationsCount &&
          openTicketsCount == other.openTicketsCount &&
          lowStockProductsCount == other.lowStockProductsCount;

  @override
  int get hashCode =>
      pendingOrdersCount.hashCode ^
      unreadNotificationsCount.hashCode ^
      openTicketsCount.hashCode ^
      lowStockProductsCount.hashCode;

  @override
  String toString() =>
      'NavigationBadgesModel(pendingOrders: $pendingOrdersCount, notifications: $unreadNotificationsCount, tickets: $openTicketsCount, lowStock: $lowStockProductsCount)';
}
