import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';

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

  factory DashboardStatsEntity.initial() => const DashboardStatsEntity(
        totalRevenue: 0.0,
        totalOrders: 0,
        totalUsers: 0,
        totalProducts: 0,
        orders: [],
        products: [],
        categories: [],
        pendingOrders: 0,
        processingOrders: 0,
        shippedOrders: 0,
        deliveredOrders: 0,
        cancelledOrders: 0,
        inStock: 0,
        lowStock: 0,
        outOfStock: 0,
      );
}
