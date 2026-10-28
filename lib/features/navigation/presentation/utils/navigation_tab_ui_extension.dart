import 'package:flutter/material.dart';
import '../../domain/entities/navigation_tab.dart';

/// Presentation-layer extension mapping pure domain [NavigationTab] to Flutter UI icons.
/// Keeps the domain entity 100% pure Dart while giving presentation widgets seamless icon access.
extension NavigationTabUiExtension on NavigationTab {
  IconData get icon {
    switch (this) {
      case NavigationTab.dashboard:
        return Icons.dashboard_outlined;
      case NavigationTab.categories:
        return Icons.category_outlined;
      case NavigationTab.products:
        return Icons.inventory_2_outlined;
      case NavigationTab.promos:
        return Icons.add_business_outlined;
      case NavigationTab.orders:
        return Icons.local_shipping_outlined;
      case NavigationTab.users:
        return Icons.people_outline;
      case NavigationTab.notifications:
        return Icons.notifications_outlined;
      case NavigationTab.settings:
        return Icons.settings_outlined;
      case NavigationTab.support:
        return Icons.support_agent_outlined;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case NavigationTab.dashboard:
        return Icons.dashboard_rounded;
      case NavigationTab.categories:
        return Icons.category_rounded;
      case NavigationTab.products:
        return Icons.inventory_2_rounded;
      case NavigationTab.promos:
        return Icons.add_business_rounded;
      case NavigationTab.orders:
        return Icons.local_shipping_rounded;
      case NavigationTab.users:
        return Icons.people_rounded;
      case NavigationTab.notifications:
        return Icons.notifications_rounded;
      case NavigationTab.settings:
        return Icons.settings_rounded;
      case NavigationTab.support:
        return Icons.support_agent_rounded;
    }
  }
}
