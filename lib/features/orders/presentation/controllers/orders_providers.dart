import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/network/dio_provider.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import '../../data/datasources/order_local_datasource.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'order_details_controller.dart';
import 'orders_notifier.dart';

export 'order_details_controller.dart';
export 'orders_notifier.dart';

// ==========================================
// Data Layer Scoped Providers
// ==========================================

/// Scoped provider for Orders Hive Cache Box
final orderHiveBoxProvider = Provider<Box<OrderModel>>((ref) {
  return Hive.box<OrderModel>('orders');
});

/// Scoped provider for [OrderLocalDataSource]
final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {
  final box = ref.watch(orderHiveBoxProvider);
  return OrderLocalDataSourceImpl(box: box);
});

/// Scoped provider for [OrderRemoteDataSource]
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRemoteDataSourceImpl(dio);
});

// ==========================================
// Domain Layer Scoped Providers
// ==========================================

/// Scoped provider for [OrderRepository] acting as Single Source of Truth
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
    localDataSource: ref.watch(orderLocalDataSourceProvider),
  );
});

/// Scoped provider for [GetOrdersUseCase]
final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  return GetOrdersUseCase(ref.watch(orderRepositoryProvider));
});

/// Scoped provider for [GetOrderDetailUseCase]
final getOrderDetailUseCaseProvider = Provider<GetOrderDetailUseCase>((ref) {
  return GetOrderDetailUseCase(ref.watch(orderRepositoryProvider));
});

/// Scoped provider for [UpdateOrderStatusUseCase]
final updateOrderStatusUseCaseProvider = Provider<UpdateOrderStatusUseCase>((
  ref,
) {
  return UpdateOrderStatusUseCase(ref.watch(orderRepositoryProvider));
});

// ==========================================
// Search, Filter & Pagination Providers
// ==========================================

/// Notifier managing orders search keyword
class OrdersSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final ordersSearchQueryProvider =
    NotifierProvider<OrdersSearchQueryNotifier, String>(
      OrdersSearchQueryNotifier.new,
    );

/// Notifier managing selected order status filter ('all', 'pending', etc.)
class OrdersSelectedStatusNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setStatus(String status) => state = status;
}

final ordersSelectedStatusProvider =
    NotifierProvider<OrdersSelectedStatusNotifier, String>(
      OrdersSelectedStatusNotifier.new,
    );

/// Notifier managing current table pagination index
class OrdersCurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void setPage(int page) => state = page;
  void nextPage(int maxPages) {
    if (state < maxPages) state++;
  }

  void previousPage() {
    if (state > 1) state--;
  }
}

final ordersCurrentPageProvider =
    NotifierProvider<OrdersCurrentPageNotifier, int>(
      OrdersCurrentPageNotifier.new,
    );

/// Page size configuration
final ordersItemsPerPageProvider = Provider<int>((ref) => 6);

// ==========================================
// Core State Providers
// ==========================================

/// Main state controller provider managing orders list
final ordersControllerProvider =
    AsyncNotifierProvider<OrdersNotifier, List<OrderEntity>>(
      OrdersNotifier.new,
    );

/// Auto-disposing family provider for order details controller
final orderDetailsControllerProvider = Provider.autoDispose
    .family<OrderDetailsController, OrderEntity>((ref, initialOrder) {
      final updateUseCase = ref.watch(updateOrderStatusUseCaseProvider);
      final controller = OrderDetailsController(
        initialOrder: initialOrder,
        updateOrderStatusUseCase: updateUseCase,
        currency: () => ref.read(storeCurrencyProvider),
        onStatusUpdated: () {
          ref
              .read(ordersControllerProvider.notifier)
              .refreshOrders(forceRefresh: true);
        },
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

// ==========================================
// Computed Selectors
// ==========================================

/// Provider filtering orders list based on query and selected status
final filteredOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final ordersAsync = ref.watch(ordersControllerProvider);
  final query = ref.watch(ordersSearchQueryProvider).toLowerCase().trim();
  final selectedStatus = ref.watch(ordersSelectedStatusProvider);

  return ordersAsync.maybeWhen(
    data: (orders) {
      var filtered = orders.where((order) {
        final matchesStatus =
            selectedStatus == 'all' || order.status.name == selectedStatus;

        final matchesQuery =
            query.isEmpty ||
            order.id.toLowerCase().contains(query) ||
            order.userId.toLowerCase().contains(query) ||
            order.userName.toLowerCase().contains(query) ||
            order.userEmail.toLowerCase().contains(query) ||
            (order.phoneNumber?.toLowerCase().contains(query) ?? false);

        return matchesStatus && matchesQuery;
      }).toList();

      filtered.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return filtered;
    },
    orElse: () => const [],
  );
});

/// Provider computing total available pages
final ordersTotalPagesProvider = Provider<int>((ref) {
  final filtered = ref.watch(filteredOrdersProvider);
  final itemsPerPage = ref.watch(ordersItemsPerPageProvider);
  if (filtered.isEmpty) return 1;
  return (filtered.length / itemsPerPage).ceil();
});

/// Provider returning sliced orders for current page
final paginatedOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final filtered = ref.watch(filteredOrdersProvider);
  final currentPage = ref.watch(ordersCurrentPageProvider);
  final itemsPerPage = ref.watch(ordersItemsPerPageProvider);

  final start = (currentPage - 1) * itemsPerPage;
  if (start >= filtered.length) return const [];
  final end = (start + itemsPerPage).clamp(0, filtered.length);
  return filtered.sublist(start, end);
});

/// Data class holding order metrics
class OrdersStats {
  final int totalOrders;
  final double totalRevenue;
  final int pendingOrders;
  final int deliveredOrders;

  const OrdersStats({
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.pendingOrders = 0,
    this.deliveredOrders = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersStats &&
          runtimeType == other.runtimeType &&
          totalOrders == other.totalOrders &&
          totalRevenue == other.totalRevenue &&
          pendingOrders == other.pendingOrders &&
          deliveredOrders == other.deliveredOrders;

  @override
  int get hashCode =>
      totalOrders.hashCode ^
      totalRevenue.hashCode ^
      pendingOrders.hashCode ^
      deliveredOrders.hashCode;
}

/// Selective provider for quick stats strip, avoiding table rebuilds
final ordersStatsProvider = Provider<OrdersStats>((ref) {
  final orders = ref.watch(
    ordersControllerProvider.select((asyncVal) => asyncVal.value ?? const []),
  );

  final total = orders.length;
  final revenue = orders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
  final pending = orders.where((o) => o.status == OrderStatus.pending).length;
  final delivered = orders
      .where((o) => o.status == OrderStatus.delivered)
      .length;

  return OrdersStats(
    totalOrders: total,
    totalRevenue: revenue,
    pendingOrders: pending,
    deliveredOrders: delivered,
  );
});
