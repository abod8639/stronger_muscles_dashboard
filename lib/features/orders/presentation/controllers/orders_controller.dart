import 'package:get/get.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';

class OrdersController extends GetxController {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersController({required this.getOrdersUseCase});

  final allOrders = <OrderEntity>[].obs;
  final filteredOrders = <OrderEntity>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedStatusId = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final result = await getOrdersUseCase();
      allOrders.assignAll(result);
      applyFilters();
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void onStatusChanged(String statusId) {
    selectedStatusId.value = statusId;
    applyFilters();
  }

  void applyFilters() {
    var result = allOrders.where((order) {
      final matchesStatus = selectedStatusId.value == 'all' || 
                           order.status.name == selectedStatusId.value;
      
      final query = searchQuery.value.toLowerCase();
      final matchesSearch = query.isEmpty ||
          order.id.toLowerCase().contains(query) ||
          order.userName.toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

    filteredOrders.assignAll(result);
  }
}
