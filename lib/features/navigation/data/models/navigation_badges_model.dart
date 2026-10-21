import 'package:flutter/foundation.dart';
import '../../domain/entities/navigation_badges_entity.dart';

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

  NavigationBadgesEntity toEntity() => NavigationBadgesEntity(
        pendingOrdersCount: pendingOrdersCount,
        unreadNotificationsCount: unreadNotificationsCount,
        openTicketsCount: openTicketsCount,
        lowStockProductsCount: lowStockProductsCount,
      );

  Map<String, dynamic> toJson() => {
        'pending_orders': pendingOrdersCount,
        'unread_notifications': unreadNotificationsCount,
        'open_tickets': openTicketsCount,
        'low_stock_products': lowStockProductsCount,
      };
}

/// دالة Isolate لتحليل الـ JSON الخاص بشارات التنقل في الخلفية
NavigationBadgesModel parseNavigationBadgesCompute(dynamic rawJson) {
  try {
    if (rawJson is Map<String, dynamic>) {
      final data = rawJson['data'] is Map ? rawJson['data'] : rawJson;
      return NavigationBadgesModel.fromJson(Map<String, dynamic>.from(data));
    } else if (rawJson is Map) {
      final data = rawJson['data'] is Map ? rawJson['data'] : rawJson;
      return NavigationBadgesModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const NavigationBadgesModel();
  } catch (e) {
    debugPrint('parseNavigationBadgesCompute fallback triggered: $e');
    return const NavigationBadgesModel();
  }
}
