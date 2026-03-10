import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/repositories/product_repository.dart';
import 'package:stronger_muscles_dashboard/features/users/domain/repositories/user_repository.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';

class DashboardController extends GetxController {
  // --- Repositories ---
  late final OrderRepository _orderRepository;
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;
  late final UserRepository _userRepository;
  late final ApiService _apiService; // Still used for connection check placeholder

  // --- UI States ---
  final isLoading = true.obs;
  final isConnected = false.obs;
  final errorMessage = ''.obs;

  // --- Period Filter Configuration ---
  final selectPeriod = 'week'.obs;

  final List<Map<String, String>> periodItems = const [
    {'id': 'week', 'name': 'هذا الأسبوع'},
    {'id': 'month', 'name': 'هذا الشهر'},
    {'id': 'year', 'name': 'هذا العام'},
  ];

  // --- Dashboard Data Counters ---
  final totalRevenue = 0.0.obs;
  final totalOrders = 0.obs;
  final totalUsers = 0.obs;
  final totalProducts = 0.obs;

  // Lists - using Entities instead of Models for consistency with clean architecture
  final orders = <OrderEntity>[].obs;
  final products = <ProductEntity>[].obs;
  final categories = <CategoryEntity>[].obs;

  // Order Status Counters
  final pendingOrders = 0.obs;
  final processingOrders = 0.obs;
  final shippedOrders = 0.obs;
  final deliveredOrders = 0.obs;
  final cancelledOrders = 0.obs;

  // Stock Status Counters
  final productsInStock = 0.obs;
  final productsLowStock = 0.obs;
  final productsOutOfStock = 0.obs;

  // --- Debounce Mechanism ---
  DateTime? _lastFetchTime;
  static const Duration _minFetchInterval = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    ever(selectPeriod, (_) => fetchDashboardData());
    _checkInitialConnection();
  }

  void _initializeDependencies() {
    _orderRepository = Get.find<OrderRepository>();
    _productRepository = Get.find<ProductRepository>();
    _categoryRepository = Get.find<CategoryRepository>();
    _userRepository = Get.find<UserRepository>();
    _apiService = Get.find<ApiService>();
  }

  Future<void> _checkInitialConnection() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final connected = await _apiService.checkConnection();
      isConnected.value = connected;

      if (!connected) {
        errorMessage.value =
            'لا يمكن الاتصال بالخادم. يرجى التحقق من الإنترنت.';
        isLoading.value = false;
        return;
      }

      await fetchDashboardData();
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء الاتصال: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDashboardData() async {
    final now = DateTime.now();
    if (_lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _minFetchInterval) {
      return;
    }
    _lastFetchTime = now;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _orderRepository.getOrders(),
        _productRepository.getProducts(),
        _categoryRepository.getCategories(),
        _userRepository.getUsersStats(),
      ]);

      orders.assignAll(results[0] as List<OrderEntity>);
      products.assignAll(results[1] as List<ProductEntity>);
      categories.assignAll(results[2] as List<CategoryEntity>);
      
      final usersStats = results[3] as Map<String, dynamic>;
      _updateUsersCount(usersStats);

      _calculateStatistics();
    } catch (e) {
      errorMessage.value = 'فشل في تحديث البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _updateUsersCount(Map<String, dynamic> usersStats) {
    if (usersStats.containsKey('total_users')) {
      totalUsers.value =
          int.tryParse(usersStats['total_users'].toString()) ?? 0;
    } else if (usersStats['data'] != null) {
      totalUsers.value =
          int.tryParse(usersStats['data']['total_users'].toString()) ?? 0;
    }
  }

  void _calculateStatistics() {
    // 1. Order Stats
    pendingOrders.value = orders
        .where((o) => o.status == OrderStatus.pending)
        .length;
    processingOrders.value = orders
        .where((o) => o.status == OrderStatus.processing)
        .length;
    shippedOrders.value = orders
        .where((o) => o.status == OrderStatus.shipped)
        .length;
    deliveredOrders.value = orders
        .where((o) => o.status == OrderStatus.delivered)
        .length;
    cancelledOrders.value = orders
        .where((o) => o.status == OrderStatus.cancelled)
        .length;

    // 2. Financials
    totalRevenue.value = orders
        .where((o) => o.status != OrderStatus.cancelled)
        .fold(0.0, (sum, order) => sum + order.totalAmount);

    totalOrders.value = orders.length;
    totalProducts.value = products.length;

    // 3. Stock Stats
    productsInStock.value = products.where((p) => p.stockQuantity > 10).length;
    productsLowStock.value = products
        .where((p) => p.stockQuantity > 0 && p.stockQuantity <= 10)
        .length;
    productsOutOfStock.value = products
        .where((p) => p.stockQuantity == 0)
        .length;
  }

  void updatePeriod(String periodId) {
    selectPeriod.value = periodId;
  }

  Future<void> retryConnection() async {
    await _checkInitialConnection();
  }
}
