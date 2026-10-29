import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';

/// Pure Dart Domain Entity representing consolidated Dashboard statistics.
/// 100% pure Dart: zero imports from Flutter UI, Dio, Hive, or 3rd-party SDKs.
class DashboardStatsEntity {
  final double totalRevenue;
  final int totalOrders;
  final int totalUsers;
  final int totalProducts;
  final List<OrderEntity> orders;
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;

  // Order status counts
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;

  // Stock status counts
  final int inStock;
  final int lowStock;
  final int outOfStock;

  const DashboardStatsEntity({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalUsers,
    required this.totalProducts,
    required this.orders,
    required this.products,
    required this.categories,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
  });

  const DashboardStatsEntity.initial()
    : totalRevenue = 0.0,
      totalOrders = 0,
      totalUsers = 0,
      totalProducts = 0,
      orders = const [],
      products = const [],
      categories = const [],
      pendingOrders = 0,
      processingOrders = 0,
      shippedOrders = 0,
      deliveredOrders = 0,
      cancelledOrders = 0,
      inStock = 0,
      lowStock = 0,
      outOfStock = 0;

  DashboardStatsEntity copyWith({
    double? totalRevenue,
    int? totalOrders,
    int? totalUsers,
    int? totalProducts,
    List<OrderEntity>? orders,
    List<ProductEntity>? products,
    List<CategoryEntity>? categories,
    int? pendingOrders,
    int? processingOrders,
    int? shippedOrders,
    int? deliveredOrders,
    int? cancelledOrders,
    int? inStock,
    int? lowStock,
    int? outOfStock,
  }) {
    return DashboardStatsEntity(
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalOrders: totalOrders ?? this.totalOrders,
      totalUsers: totalUsers ?? this.totalUsers,
      totalProducts: totalProducts ?? this.totalProducts,
      orders: orders ?? this.orders,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      processingOrders: processingOrders ?? this.processingOrders,
      shippedOrders: shippedOrders ?? this.shippedOrders,
      deliveredOrders: deliveredOrders ?? this.deliveredOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      inStock: inStock ?? this.inStock,
      lowStock: lowStock ?? this.lowStock,
      outOfStock: outOfStock ?? this.outOfStock,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardStatsEntity &&
        other.totalRevenue == totalRevenue &&
        other.totalOrders == totalOrders &&
        other.totalUsers == totalUsers &&
        other.totalProducts == totalProducts &&
        other.pendingOrders == pendingOrders &&
        other.processingOrders == processingOrders &&
        other.shippedOrders == shippedOrders &&
        other.deliveredOrders == deliveredOrders &&
        other.cancelledOrders == cancelledOrders &&
        other.inStock == inStock &&
        other.lowStock == lowStock &&
        other.outOfStock == outOfStock;
  }

  @override
  int get hashCode => Object.hash(
    totalRevenue,
    totalOrders,
    totalUsers,
    totalProducts,
    pendingOrders,
    processingOrders,
    shippedOrders,
    deliveredOrders,
    cancelledOrders,
    inStock,
    lowStock,
    outOfStock,
  );

  @override
  String toString() =>
      'DashboardStatsEntity(revenue: $totalRevenue, orders: $totalOrders, users: $totalUsers, products: $totalProducts)';
}
