/// Data Transfer Object (DTO) for Dashboard statistics.
/// Decoupled from [DashboardStatsEntity] to maintain strict Clean Architecture boundaries.
class DashboardStatsModel {
  final double totalRevenue;
  final int totalOrders;
  final int totalUsers;
  final int totalProducts;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final int inStock;
  final int lowStock;
  final int outOfStock;

  const DashboardStatsModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalUsers,
    required this.totalProducts,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return DashboardStatsModel(
      totalRevenue: parseDouble(json['total_revenue'] ?? json['totalRevenue']),
      totalOrders: parseInt(json['total_orders'] ?? json['totalOrders']),
      totalUsers: parseInt(json['total_users'] ?? json['totalUsers']),
      totalProducts: parseInt(json['total_products'] ?? json['totalProducts']),
      pendingOrders: parseInt(json['pending_orders'] ?? json['pendingOrders']),
      processingOrders: parseInt(json['processing_orders'] ?? json['processingOrders']),
      shippedOrders: parseInt(json['shipped_orders'] ?? json['shippedOrders']),
      deliveredOrders: parseInt(json['delivered_orders'] ?? json['deliveredOrders']),
      cancelledOrders: parseInt(json['cancelled_orders'] ?? json['cancelledOrders']),
      inStock: parseInt(json['in_stock'] ?? json['inStock']),
      lowStock: parseInt(json['low_stock'] ?? json['lowStock']),
      outOfStock: parseInt(json['out_of_stock'] ?? json['outOfStock']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'total_orders': totalOrders,
      'total_users': totalUsers,
      'total_products': totalProducts,
      'pending_orders': pendingOrders,
      'processing_orders': processingOrders,
      'shipped_orders': shippedOrders,
      'delivered_orders': deliveredOrders,
      'cancelled_orders': cancelledOrders,
      'in_stock': inStock,
      'low_stock': lowStock,
      'out_of_stock': outOfStock,
    };
  }
}
