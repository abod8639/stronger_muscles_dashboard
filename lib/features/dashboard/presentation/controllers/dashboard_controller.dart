import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';

class DashboardController extends GetxController {
  final GetDashboardDataUseCase _getDashboardDataUseCase;

  DashboardController({
    required GetDashboardDataUseCase getDashboardDataUseCase,
  }) : _getDashboardDataUseCase = getDashboardDataUseCase;

  // --- UI States ---
  final isLoading = true.obs;
  final isConnected = true.obs; // Defaults to true if we're calling fetch
  final errorMessage = ''.obs;

  // --- Dashboard Data ---
  final stats = DashboardStatsEntity.initial().obs;

  // --- Period Filter Configuration ---
  final selectPeriod = 'week'.obs;

  final List<Map<String, String>> periodItems = const [
    {'id': 'week', 'name': 'هذا الأسبوع'},
    {'id': 'month', 'name': 'هذا الشهر'},
    {'id': 'year', 'name': 'هذا العام'},
  ];

  @override
  void onInit() {
    super.onInit();
    ever(selectPeriod, (_) => fetchDashboardData());
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getDashboardDataUseCase();
      stats.value = result;
      isConnected.value = true;
    } catch (e) {
      errorMessage.value = 'فشل في تحديث البيانات: $e';
      isConnected.value = false;
      debugPrint('Dashboard Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updatePeriod(String periodId) {
    selectPeriod.value = periodId;
  }

  Future<void> retryConnection() async {
    await fetchDashboardData();
  }
}
