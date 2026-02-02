import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../services/api_service.dart';

class OrdersController extends GetxController {
  final OrderRepository _repository = OrderRepository(ApiService());

  final RxList<OrderModel> _allOrders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  // Statistics Getters
  int get totalOrders => _allOrders.length;
  double get totalRevenue =>
      _allOrders.fold(0, (sum, order) => sum + order.totalAmount);
  int get pendingOrders =>
      _allOrders.where((o) => o.status == OrderStatus.pending).length;
  int get deliveredOrders =>
      _allOrders.where((o) => o.status == OrderStatus.delivered).length;

  // نستخدم String ليتوافق مع الـ 'all' ومع الـ IDs الخاصة بالحالات
  final RxString selectedStatusId = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    // مراقبة التغيرات وتحديث الفلترة تلقائياً (Worker)
    debounce(searchQuery, (_) => _applyFilters(), time: 300.milliseconds);
    ever(selectedStatusId, (_) => _applyFilters());

    fetchOrders();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;

    _applyFilters();
  }

  /// تحويل الـ Enum إلى قائمة متوافقة مع الـ HorizontalChipsSelector
  List<Map<String, String>> get statusItems {
    return OrderStatus.values.map((status) {
      return {
        'id': status.name, // نستخدم اسم الـ enum كمعرف (e.g., 'pending')
        'name': getStatusText(status),
      };
    }).toList();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final orders = await _repository.getOrders();
      _allOrders.assignAll(orders);
      _applyFilters();
    } catch (e) {
      errorMessage.value = 'فشل في تحميل الطلبات: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var result = _allOrders.where((order) {
      // 1. الفلترة حسب الحالة
      final bool matchesStatus =
          selectedStatusId.value == 'all' ||
          order.status.name == selectedStatusId.value;

      // 2. الفلترة حسب البحث
      final String query = searchQuery.value.toLowerCase();
      final bool matchesSearch =
          query.isEmpty ||
          order.id.toString().contains(query) ||
          order.userId.toString().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

    // الترتيب: الأحدث أولاً
    result.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    filteredOrders.assignAll(result);
  }

  // --- Helpers ---

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'قيد الانتظار';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
