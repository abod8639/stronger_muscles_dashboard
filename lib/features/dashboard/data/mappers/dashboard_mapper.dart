import 'package:stronger_muscles_dashboard/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';

/// Extension Mappers converting between [DashboardStatsModel] DTO and pure [DashboardStatsEntity].
extension DashboardStatsModelMapper on DashboardStatsModel {
  DashboardStatsEntity toEntity() {
    return DashboardStatsEntity(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      totalUsers: totalUsers,
      totalProducts: totalProducts,
      orders: const [],
      products: const [],
      categories: const [],
      pendingOrders: pendingOrders,
      processingOrders: processingOrders,
      shippedOrders: shippedOrders,
      deliveredOrders: deliveredOrders,
      cancelledOrders: cancelledOrders,
      inStock: inStock,
      lowStock: lowStock,
      outOfStock: outOfStock,
    );
  }
}

extension DashboardStatsEntityMapper on DashboardStatsEntity {
  DashboardStatsModel toModel() {
    return DashboardStatsModel(
      totalRevenue: totalRevenue,
      totalOrders: totalOrders,
      totalUsers: totalUsers,
      totalProducts: totalProducts,
      pendingOrders: pendingOrders,
      processingOrders: processingOrders,
      shippedOrders: shippedOrders,
      deliveredOrders: deliveredOrders,
      cancelledOrders: cancelledOrders,
      inStock: inStock,
      lowStock: lowStock,
      outOfStock: outOfStock,
    );
  }
}
