import 'package:stronger_muscles_dashboard/features/navigation/data/models/navigation_badges_model.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_badges_entity.dart';

/// Extension mappers converting bidirectionally between [NavigationBadgesModel] and [NavigationBadgesEntity].
extension NavigationBadgesModelMapper on NavigationBadgesModel {
  NavigationBadgesEntity toEntity() {
    return NavigationBadgesEntity(
      pendingOrdersCount: pendingOrdersCount,
      unreadNotificationsCount: unreadNotificationsCount,
      openTicketsCount: openTicketsCount,
      lowStockProductsCount: lowStockProductsCount,
    );
  }
}

extension NavigationBadgesEntityMapper on NavigationBadgesEntity {
  NavigationBadgesModel toModel() {
    return NavigationBadgesModel(
      pendingOrdersCount: pendingOrdersCount,
      unreadNotificationsCount: unreadNotificationsCount,
      openTicketsCount: openTicketsCount,
      lowStockProductsCount: lowStockProductsCount,
    );
  }
}
