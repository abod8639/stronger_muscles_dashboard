import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/controllers/auth_providers.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'order_details_controller.dart';

// ==========================================
// Data & Domain Providers
// ==========================================

/// موفر مصدر بيانات الطلبات البعيد
final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRemoteDataSourceImpl(dio);
});

/// موفر مستودع الطلبات
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remoteDataSource = ref.watch(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// موفرات حالات الاستخدام (UseCases)
final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  return GetOrdersUseCase(ref.watch(orderRepositoryProvider));
});

final getOrderDetailUseCaseProvider = Provider<GetOrderDetailUseCase>((ref) {
  return GetOrderDetailUseCase(ref.watch(orderRepositoryProvider));
});

final updateOrderStatusUseCaseProvider =
    Provider<UpdateOrderStatusUseCase>((ref) {
  return UpdateOrderStatusUseCase(ref.watch(orderRepositoryProvider));
});

// ==========================================
// Search & Filter State Notifiers
// ==========================================

/// موفر نص البحث في الطلبات
class OrdersSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final ordersSearchQueryProvider =
    NotifierProvider<OrdersSearchQueryNotifier, String>(
  OrdersSearchQueryNotifier.new,
);

/// موفر تبويب تصفية الحالة المحدد (all, pending, processing, shipped, delivered, cancelled)
class OrdersSelectedStatusNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setStatus(String status) => state = status;
}

final ordersSelectedStatusProvider =
    NotifierProvider<OrdersSelectedStatusNotifier, String>(
  OrdersSelectedStatusNotifier.new,
);

/// موفر الصفحة الحالية للتقسيم (Pagination)
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

/// عدد العناصر في الصفحة الواحدة
final ordersItemsPerPageProvider = Provider<int>((ref) => 6);

// ==========================================
// Core Orders State via AsyncNotifier
// ==========================================

/// متحكم حالة الطلبات الرئيسي عبر [AsyncNotifier]
/// يدعم إلغاء الطلبات عبر `ref.onDispose` لمنع تسريب الموارد
/// ويحول `Either<Failure, T>` إلى `AsyncValue` بأمان لمنع الانهيار
class OrdersNotifier extends AsyncNotifier<List<OrderEntity>> {
  CancelToken? _cancelToken;

  @override
  FutureOr<List<OrderEntity>> build() {
    // إدارة الإلغاء عبر ref.onDispose لمنع تسريب الموارد
    ref.onDispose(() {
      _cancelToken?.cancel('تم إلغاء طلبات إدارة الطلبات بسبب تفريغ الـ Notifier');
      _cancelToken = null;
    });

    return _fetchOrders(forceRefresh: false);
  }

  Future<List<OrderEntity>> _fetchOrders({bool forceRefresh = false}) async {
    _cancelToken?.cancel('طلب جديد لقائمة الطلبات');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final getOrders = ref.read(getOrdersUseCaseProvider);
    final result = await getOrders(
      forceRefresh: forceRefresh,
      cancelToken: cancelToken,
    );

    return result.fold(
      (failure) => throw failure,
      (orders) => orders,
    );
  }

  /// إعادة تحميل الطلبات مع إجبار تحديث الـ Cache
  Future<void> refreshOrders({bool forceRefresh = true}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetchOrders(forceRefresh: forceRefresh),
    );
  }

  /// تحديث حالة الطلب ومزامنة الحالة فورياً
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    final updateUseCase = ref.read(updateOrderStatusUseCaseProvider);
    final previousState = state;

    final result = await updateUseCase(orderId, newStatus);

    result.fold(
      (failure) {
        // الحفاظ على الحالة السابقة وعدم إخفاء الشاشة عند فشل التحديث
      },
      (updatedOrder) {
        final currentList = List<OrderEntity>.from(previousState.value ?? const []);
        final index = currentList.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          currentList[index] = updatedOrder;
          state = AsyncValue.data(currentList);
        }
      },
    );

    return result;
  }

  /// تنظيف الخطأ واستعادة آخر بيانات مسترجعة
  void clearError() {
    if (state.hasError) {
      state = AsyncValue.data(state.value ?? const []);
    }
  }
}

final ordersControllerProvider =
    AsyncNotifierProvider<OrdersNotifier, List<OrderEntity>>(
  OrdersNotifier.new,
);

// ==========================================
// Order Details Controller Provider
// ==========================================

final orderDetailsControllerProvider = Provider.autoDispose
    .family<OrderDetailsController, OrderEntity>((ref, initialOrder) {
  final updateUseCase = ref.watch(updateOrderStatusUseCaseProvider);
  final controller = OrderDetailsController(
    initialOrder: initialOrder,
    updateOrderStatusUseCase: updateUseCase,
    onStatusUpdated: () {
      ref.read(ordersControllerProvider.notifier).refreshOrders(forceRefresh: true);
    },
  );
  ref.onDispose(controller.dispose);
  return controller;
});

// ==========================================
// Computed Selectors / Providers
// ==========================================

/// موفر قائمة الطلبات المفلترة بحسب البحث وحالة التصفية
final filteredOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final ordersAsync = ref.watch(ordersControllerProvider);
  final query = ref.watch(ordersSearchQueryProvider).toLowerCase().trim();
  final selectedStatus = ref.watch(ordersSelectedStatusProvider);

  return ordersAsync.maybeWhen(
    data: (orders) {
      var filtered = orders.where((order) {
        final matchesStatus =
            selectedStatus == 'all' || order.status.name == selectedStatus;

        final matchesQuery = query.isEmpty ||
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

/// موفر إجمالي الصفحات
final ordersTotalPagesProvider = Provider<int>((ref) {
  final filtered = ref.watch(filteredOrdersProvider);
  final itemsPerPage = ref.watch(ordersItemsPerPageProvider);
  if (filtered.isEmpty) return 1;
  return (filtered.length / itemsPerPage).ceil();
});

/// موفر صفحة الطلبات المقتطعة للجدول الحالي
final paginatedOrdersProvider = Provider<List<OrderEntity>>((ref) {
  final filtered = ref.watch(filteredOrdersProvider);
  final currentPage = ref.watch(ordersCurrentPageProvider);
  final itemsPerPage = ref.watch(ordersItemsPerPageProvider);

  final start = (currentPage - 1) * itemsPerPage;
  if (start >= filtered.length) return const [];
  final end = (start + itemsPerPage).clamp(0, filtered.length);
  return filtered.sublist(start, end);
});

/// فئة بيانات إحصائيات الطلبات
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
}

/// موفر إحصائيات ومؤشرات الأداء السريعة للطلبات
final ordersStatsProvider = Provider<OrdersStats>((ref) {
  final ordersAsync = ref.watch(ordersControllerProvider);
  return ordersAsync.maybeWhen(
    data: (orders) {
      final total = orders.length;
      final revenue = orders.fold<double>(0.0, (sum, o) => sum + o.totalAmount);
      final pending = orders.where((o) => o.status == OrderStatus.pending).length;
      final delivered = orders.where((o) => o.status == OrderStatus.delivered).length;
      return OrdersStats(
        totalOrders: total,
        totalRevenue: revenue,
        pendingOrders: pending,
        deliveredOrders: delivered,
      );
    },
    orElse: () => const OrdersStats(),
  );
});
