import 'package:stronger_muscles_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;
  final UserRepository _userRepository;

  DashboardRepositoryImpl({
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
    required CategoryRepository categoryRepository,
    required UserRepository userRepository,
  })  : _orderRepository = orderRepository,
        _productRepository = productRepository,
        _categoryRepository = categoryRepository,
        _userRepository = userRepository;

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    final results = await Future.wait([
      _orderRepository.getOrders(),
      _productRepository.getProducts(),
      _categoryRepository.getCategories(),
      _userRepository.getUsersStats(),
    ]);

    final orderModels = results[0] as List;
    final productModels = results[1] as List;
    final categoryModels = results[2] as List;
    final usersStats = results[3]; // UsersStatsEntity

    final List<dynamic>  orders = orderModels.map((m) => m.toEntity()).toList();
    final List<dynamic> products = productModels.map((m) => m.toEntity()).toList();
    final List<dynamic> categories = categoryModels.map((m) => m.toEntity()).toList();

    // 1. Order Status Counts
    int pending = 0;
    int processing = 0;
    int shipped = 0;
    int delivered = 0;
    int cancelled = 0;

    for (var o in orders) {
      switch (o.status) {
        case OrderStatus.pending:
          pending++;
          break;
        case OrderStatus.processing:
          processing++;
          break;
        case OrderStatus.shipped:
          shipped++;
          break;
        case OrderStatus.delivered:
          delivered++;
          break;
        case OrderStatus.cancelled:
          cancelled++;
          break;
      }
    }

    // 2. Financials
    double revenue = 0.0;
    for (var o in orders) {
      if (o.status != OrderStatus.cancelled) {
        revenue += o.totalAmount;
      }
    }

    // 3. Stock stats
    int inStock = 0;
    int lowStock = 0;
    int outOfStock = 0;

    for (var p in products) {
      if (p.stockQuantity > 10) {
        inStock++;
      } else if (p.stockQuantity > 0) {
        lowStock++;
      } else {
        outOfStock++;
      }
    }

    return DashboardStatsEntity(
      totalRevenue: revenue,
      totalOrders: orders.length,
      totalUsers: usersStats.totalUsers , // From UsersStatsEntity
      totalProducts: products.length,
      orders: orders as List<OrderEntity>,
      products: products as List<ProductEntity>,
      categories: categories as List<CategoryEntity>,
      pendingOrders: pending,
      processingOrders: processing,
      shippedOrders: shipped,
      deliveredOrders: delivered,
      cancelledOrders: cancelled,
      inStock: inStock,
      lowStock: lowStock,
      outOfStock: outOfStock,
    );
  }
}
