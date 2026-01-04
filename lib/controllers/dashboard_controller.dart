import 'package:get/get.dart';
import '../models/index.dart';
import '../services/api_service.dart';
import '../repositories/index.dart';

class DashboardController extends GetxController {
  // Services
  late final ApiService _apiService;
  late final OrderRepository _orderRepository;
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;

  // متغيرات الحالة
  final isLoading = true.obs;
  final isConnected = false.obs;
  final errorMessage = ''.obs;
  final selectedPeriod = 'week'.obs; // week, month, year

  // بيانات الإحصائيات
  final totalRevenue = 0.0.obs;
  final totalOrders = 0.obs;
  final totalUsers = 0.obs;
  final totalProducts = 0.obs;

  // قوائم البيانات
  final orders = <OrderModel>[].obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;

  // إحصائيات الطلبات
  final pendingOrders = 0.obs;
  final processingOrders = 0.obs;
  final shippedOrders = 0.obs;
  final deliveredOrders = 0.obs;
  final cancelledOrders = 0.obs;

  // إحصائيات المنتجات
  final productsInStock = 0.obs;
  final productsLowStock = 0.obs;
  final productsOutOfStock = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepositories();
    _checkConnectionAndFetchData();
  }

  void _initializeRepositories() {
    _apiService = ApiService();
    _orderRepository = OrderRepository(_apiService);
    _productRepository = ProductRepository(_apiService);
    _categoryRepository = CategoryRepository(_apiService);
  }

  Future<void> _checkConnectionAndFetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // التحقق من الاتصال بقاعدة البيانات
      final connected = await _apiService.checkConnection();
      isConnected.value = connected;

      if (!connected) {
        errorMessage.value = 'لا يمكن الاتصال بقاعدة البيانات. تأكد من اتصالك بالإنترنت والخادم يعمل.';
        isLoading.value = false;
        return;
      }

      // جلب البيانات من API
      await fetchDashboardData();
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'خطأ: ${e.toString()}';
      isLoading.value = false;
      print('خطأ في التحقق من الاتصال: $e');
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // جلب الطلبات
      final fetchedOrders = await _orderRepository.getOrders();
      orders.assignAll(fetchedOrders);

      // جلب المنتجات
      final fetchedProducts = await _productRepository.getProducts();
      products.assignAll(fetchedProducts);

      // جلب التصنيفات
      final fetchedCategories = await _categoryRepository.getCategories();
      categories.assignAll(fetchedCategories);

      // حساب الإحصائيات
      _calculateStatistics();
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'فشل تحميل البيانات: ${e.toString()}';
      isLoading.value = false;
      print('خطأ في جلب بيانات لوحة التحكم: $e');
    }
  }

  void _calculateStatistics() {
    // حساب إحصائيات الطلبات
    pendingOrders.value = orders.where((o) => o.status == OrderStatus.pending).length;
    processingOrders.value = orders.where((o) => o.status == OrderStatus.processing).length;
    shippedOrders.value = orders.where((o) => o.status == OrderStatus.shipped).length;
    deliveredOrders.value = orders.where((o) => o.status == OrderStatus.delivered).length;
    cancelledOrders.value = orders.where((o) => o.status == OrderStatus.cancelled).length;

    // حساب إجمالي الإيرادات
    totalRevenue.value = orders.fold(0.0, (sum, order) => sum + order.totalAmount);

    // حساب عدد الطلبات الفريدة
    totalOrders.value = orders.length;

    // حساب عدد المنتجات الفريدة
    totalProducts.value = products.length;

    // حساب إحصائيات المنتجات
    productsInStock.value = products.where((p) => p.stockQuantity > 10).length;
    productsLowStock.value = products.where((p) => p.stockQuantity > 0 && p.stockQuantity <= 10).length;
    productsOutOfStock.value = products.where((p) => p.stockQuantity == 0).length;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    // هنا يمكنك إضافة منطق لتصفية البيانات حسب الفترة المختارة
    fetchDashboardData();
  }

  // إعادة محاولة الاتصال
  Future<void> retryConnection() async {
    await _checkConnectionAndFetchData();
  }
}
