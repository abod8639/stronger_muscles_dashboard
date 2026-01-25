import 'package:get/get.dart';
import '../models/index.dart';
import '../services/api_service.dart';
import '../repositories/index.dart';

class DashboardController extends GetxController {
  // --- Repositories ---
  late final ApiService _apiService;
  late final OrderRepository _orderRepository;
  late final ProductRepository _productRepository;
  late final CategoryRepository _categoryRepository;
  late final UserRepository _userRepository;

  // --- UI States ---
  final isLoading = true.obs;
  final isConnected = false.obs;
  final errorMessage = ''.obs;

  // --- Period Filter Configuration ---
  // المعرف المختار حالياً للفترة الزمنية
  final selectPeriod = 'week'.obs; 

  // القائمة المتوافقة مع HorizontalChipsSelector
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

  // Lists
  final orders = <OrderModel>[].obs;
  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    _initializeRepositories();

    // العامل (Worker): يراقب تغيير الفترة ويحدث البيانات تلقائياً
    // سيتم تنفيذ fetchDashboardData كلما تغيرت قيمة selectPeriod
    ever(selectPeriod, (_) => fetchDashboardData());

    _checkInitialConnection();
  }

  void _initializeRepositories() {
    _apiService = ApiService();
    _orderRepository = OrderRepository(_apiService);
    _productRepository = ProductRepository(_apiService);
    _categoryRepository = CategoryRepository(_apiService);
    _userRepository = UserRepository(_apiService);
  }

  // --- Logic الدوال ---

  /// التحقق من الاتصال وبدء جلب البيانات لأول مرة
  Future<void> _checkInitialConnection() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final connected = await _apiService.checkConnection();
      isConnected.value = connected;

      if (!connected) {
        errorMessage.value = 'لا يمكن الاتصال بالخادم. يرجى التحقق من الإنترنت.';
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

  /// جلب كافة بيانات لوحة التحكم
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // ملاحظة: يمكنك تمرير selectPeriod.value للـ repository إذا كان السيرفر يدعم الفلترة الزمانية
      // مثال: await _orderRepository.getOrders(period: selectPeriod.value);

      // جلب البيانات بالتوازي لزيادة الأداء
      final results = await Future.wait([
        _orderRepository.getOrders(),
        _productRepository.getProducts(),
        _categoryRepository.getCategories(),
        _fetchUsersStats(), // جلب إحصائيات المستخدمين
      ]);

      orders.assignAll(results[0] as List<OrderModel>);
      products.assignAll(results[1] as List<ProductModel>);
      categories.assignAll(results[2] as List<CategoryModel>);

      _calculateStatistics();
      
    } catch (e) {
      errorMessage.value = 'فشل في تحديث البيانات: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// دالة فرعية لجلب إحصائيات المستخدمين
  Future<dynamic> _fetchUsersStats() async {
    try {
      final usersStats = await _userRepository.getUsersStats();
      if (usersStats.containsKey('total_users')) {
        totalUsers.value = int.tryParse(usersStats['total_users'].toString()) ?? 0;
      } else if (usersStats['data'] != null) {
        totalUsers.value = int.tryParse(usersStats['data']['total_users'].toString()) ?? 0;
      }
      return usersStats;
    } catch (e) {
      print('خطأ في إحصائيات المستخدمين: $e');
      return {};
    }
  }

  /// حساب الإحصائيات بناءً على البيانات المحملة
  void _calculateStatistics() {
    // 1. إحصائيات الطلبات
    pendingOrders.value = orders.where((o) => o.status == OrderStatus.pending).length;
    processingOrders.value = orders.where((o) => o.status == OrderStatus.processing).length;
    shippedOrders.value = orders.where((o) => o.status == OrderStatus.shipped).length;
    deliveredOrders.value = orders.where((o) => o.status == OrderStatus.delivered).length;
    cancelledOrders.value = orders.where((o) => o.status == OrderStatus.cancelled).length;

    // 2. الماليات
    totalRevenue.value = orders
        .where((o) => o.status != OrderStatus.cancelled) // لا تحسب المبيعات الملغاة
        .fold(0.0, (sum, order) => sum + order.totalAmount);

    totalOrders.value = orders.length;
    totalProducts.value = products.length;

    // 3. إحصائيات المخزون
    productsInStock.value = products.where((p) => p.stockQuantity > 10).length;
    productsLowStock.value = products.where((p) => p.stockQuantity > 0 && p.stockQuantity <= 10).length;
    productsOutOfStock.value = products.where((p) => p.stockQuantity == 0).length;
  }

  /// تغيير الفترة الزمنية يدوياً (إذا لزم الأمر)
  void updatePeriod(String periodId) {
    selectPeriod.value = periodId;
    // الـ Worker (ever) سيتكفل بالباقي
  }

  /// إعادة المحاولة عند حدوث خطأ
  Future<void> retryConnection() async {
    await _checkInitialConnection();
  }
}