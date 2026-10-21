import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/get_order_detail_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/usecases/update_order_status_usecase.dart';

/// جسر التوافقية (Compatibility Bridge) لـ GetX لضمان عمل الواجهات المتصلة بـ GetView بسلاسة
class OrdersController extends GetxController {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderDetailUseCase? _getOrderDetailUseCase;
  final UpdateOrderStatusUseCase? _updateOrderStatusUseCase;

  OrdersController({
    required GetOrdersUseCase getOrdersUseCase,
    GetOrderDetailUseCase? getOrderDetailUseCase,
    UpdateOrderStatusUseCase? updateOrderStatusUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrderDetailUseCase = getOrderDetailUseCase,
        _updateOrderStatusUseCase = updateOrderStatusUseCase;

  final RxList<OrderEntity> _allOrders = <OrderEntity>[].obs;
  final RxList<OrderEntity> filteredOrders = <OrderEntity>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isUpdatingStatus = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Failure?> currentFailure = Rx<Failure?>(null);
  final RxString searchQuery = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt itemsPerPage = 6.obs;

  // Filters
  final RxString selectedStatusId = 'all'.obs;

  List<OrderEntity> get paginatedOrders {
    final start = (currentPage.value - 1) * itemsPerPage.value;
    if (start >= filteredOrders.length) return [];
    final end = (start + itemsPerPage.value).clamp(0, filteredOrders.length);
    return filteredOrders.sublist(start, end);
  }

  int get totalPages {
    if (filteredOrders.isEmpty) return 1;
    return (filteredOrders.length / itemsPerPage.value).ceil();
  }

  // Statistics
  int get totalOrders => _allOrders.length;
  double get totalRevenue => _allOrders.fold(0.0, (sum, order) => sum + order.totalAmount);
  int get pendingOrders => _allOrders.where((o) => o.status == OrderStatus.pending).length;
  int get deliveredOrders => _allOrders.where((o) => o.status == OrderStatus.delivered).length;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => _applyFilters(), time: 300.milliseconds);
    ever(selectedStatusId, (_) => _applyFilters());
    fetchOrders();
  }

  /// مزامنة البيانات مباشرة من Riverpod لمنع تعارض الحالات
  void syncWithRiverpod(List<OrderEntity> orders) {
    _allOrders.assignAll(orders);
    _applyFilters();
    errorMessage.value = '';
    currentFailure.value = null;
    isLoading.value = false;
  }

  Future<void> fetchOrders({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentFailure.value = null;

      final result = await _getOrdersUseCase(forceRefresh: forceRefresh);

      result.fold(
        (failure) {
          currentFailure.value = failure;
          errorMessage.value = failure.toMessage();
        },
        (orders) {
          _allOrders.assignAll(orders);
          _applyFilters();
        },
      );
    } catch (e) {
      final failure = UnknownFailure(message: e.toString());
      currentFailure.value = failure;
      errorMessage.value = failure.toMessage();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    _applyFilters();
  }

  void onStatusChanged(String statusId) {
    selectedStatusId.value = statusId;
    currentPage.value = 1;
    _applyFilters();
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void previousPage() {
    if (currentPage.value > 1) currentPage.value--;
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) currentPage.value = page;
  }

  List<Map<String, String>> get statusItems {
    return OrderStatus.values.map((status) {
      return {'id': status.name, 'name': getStatusText(status)};
    }).toList();
  }

  void _applyFilters() {
    var result = _allOrders.where((order) {
      final bool matchesStatus =
          selectedStatusId.value == 'all' ||
          order.status.name == selectedStatusId.value;

      final String query = searchQuery.value.toLowerCase().trim();
      final bool matchesSearch =
          query.isEmpty ||
          order.id.toLowerCase().contains(query) ||
          order.userId.toLowerCase().contains(query) ||
          order.userName.toLowerCase().contains(query) ||
          order.userEmail.toLowerCase().contains(query) ||
          (order.phoneNumber?.toLowerCase().contains(query) ?? false);

      return matchesStatus && matchesSearch;
    }).toList();

    result.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    filteredOrders.assignAll(result);
  }

  // --- Helpers ---
  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return 'قيد الانتظار';
      case OrderStatus.processing: return 'قيد المعالجة';
      case OrderStatus.shipped: return 'تم الشحن';
      case OrderStatus.delivered: return 'تم التوصيل';
      case OrderStatus.cancelled: return 'ملغي';
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.processing: return Colors.blue;
      case OrderStatus.shipped: return Colors.purple;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
    }
  }

  /// جلب تفاصيل طلب مفرد
  Future<OrderEntity?> getOrderDetail(String id) async {
    if (_getOrderDetailUseCase == null) return null;
    final result = await _getOrderDetailUseCase(id);
    return result.fold(
      (failure) {
        Get.snackbar('خطأ', failure.toMessage());
        return null;
      },
      (order) => order,
    );
  }

  /// تحديث حالة الطلب مع معالجة الأخطاء والتحديث التفاعلي
  Future<OrderEntity?> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    if (_updateOrderStatusUseCase == null) {
      Get.snackbar('خطأ', 'خدمة تحديث حالة الطلب غير متوفرة');
      return null;
    }

    try {
      isUpdatingStatus.value = true;
      final result = await _updateOrderStatusUseCase(orderId, newStatus);

      final OrderEntity? updated = result.fold(
        (failure) {
          Get.snackbar(
            'فشل التحديث',
            failure.toMessage(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.85),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
          return null;
        },
        (updatedOrder) {
          final index = _allOrders.indexWhere((o) => o.id == orderId);
          if (index != -1) {
            _allOrders[index] = updatedOrder;
            _applyFilters();
          }

          Get.snackbar(
            'تم التحديث',
            'تم تحديث حالة الطلب إلى "${getStatusText(newStatus)}" بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );

          return updatedOrder;
        },
      );

      return updated;
    } catch (e) {
      Get.snackbar(
        'فشل التحديث',
        'تعذر تحديث حالة الطلب: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return null;
    } finally {
      isUpdatingStatus.value = false;
    }
  }
}
