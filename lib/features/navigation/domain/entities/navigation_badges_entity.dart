/// 100% Pure Dart Domain Entity representing navigation item badges.
/// Free of any framework, networking, or database library dependencies.
class NavigationBadgesEntity {
  final int pendingOrdersCount;
  final int unreadNotificationsCount;
  final int openTicketsCount;
  final int lowStockProductsCount;

  const NavigationBadgesEntity({
    required this.pendingOrdersCount,
    required this.unreadNotificationsCount,
    required this.openTicketsCount,
    required this.lowStockProductsCount,
  });

  const NavigationBadgesEntity.initial()
    : pendingOrdersCount = 0,
      unreadNotificationsCount = 0,
      openTicketsCount = 0,
      lowStockProductsCount = 0;

  NavigationBadgesEntity copyWith({
    int? pendingOrdersCount,
    int? unreadNotificationsCount,
    int? openTicketsCount,
    int? lowStockProductsCount,
  }) {
    return NavigationBadgesEntity(
      pendingOrdersCount: pendingOrdersCount ?? this.pendingOrdersCount,
      unreadNotificationsCount:
          unreadNotificationsCount ?? this.unreadNotificationsCount,
      openTicketsCount: openTicketsCount ?? this.openTicketsCount,
      lowStockProductsCount:
          lowStockProductsCount ?? this.lowStockProductsCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationBadgesEntity &&
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
      'NavigationBadgesEntity(pendingOrders: $pendingOrdersCount, notifications: $unreadNotificationsCount, tickets: $openTicketsCount, lowStock: $lowStockProductsCount)';
}
