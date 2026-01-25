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
  final Rx<OrderStatus?> selectedStatus = Rx<OrderStatus?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final orders = await _repository.getOrders();
      _allOrders.assignAll(orders);
      _applyFilters();
    } catch (e) {
      errorMessage.value = 'فشل في تحميل الطلبات: $e';
      print('OrdersController Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setFilterStatus(OrderStatus? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void _applyFilters() {
    var result = _allOrders.toList();

    // Filter by status
    if (selectedStatus.value != null) {
      result = result.where((o) => o.status == selectedStatus.value).toList();
    }

    // Filter by search query (id or user id or total amount)
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((o) {
        return o.id.toString().toLowerCase().contains(query) ||
               o.userId.toString().toLowerCase().contains(query) ||
               o.totalAmount.toString().contains(query);
      }).toList();
    }

    // Sort by date (newest first)
    result.sort((a, b) => b.orderDate.compareTo(a.orderDate));

    filteredOrders.assignAll(result);
  }

    void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
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
}
