import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import '../models/orders_chart_data.dart';

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

  /// Calculates real chart data based on loaded orders and the selected period.
  OrdersChartData get ordersChartData {
    final orders = stats.value.orders;
    final period = selectPeriod.value;

    switch (period) {
      case 'month':
        return _calculateMonthOrdersData(orders);
      case 'year':
        return _calculateYearOrdersData(orders);
      case 'week':
      default:
        return _calculateWeekOrdersData(orders);
    }
  }

  OrdersChartData _calculateWeekOrdersData(List<OrderEntity> orders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    const arabicDays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];

    final spots = <FlSpot>[];
    final bottomTitles = <String>[];
    int total = 0;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final count = orders.where((o) {
        final d = o.orderDate;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      }).length;

      total += count;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
      bottomTitles.add(arabicDays[day.weekday - 1]);
    }

    final (maxY, interval) = _calculateMaxYAndInterval(spots);

    return OrdersChartData(
      spots: spots,
      bottomTitles: bottomTitles,
      maxY: maxY,
      interval: interval,
      bottomTitleInterval: 1.0,
      periodSubtitle: 'آخر 7 أيام (إجمالي: $total طلب)',
      totalPeriodOrders: total,
    );
  }

  OrdersChartData _calculateMonthOrdersData(List<OrderEntity> orders) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(30, (i) => today.subtract(Duration(days: 29 - i)));

    final spots = <FlSpot>[];
    final bottomTitles = <String>[];
    int total = 0;

    for (int i = 0; i < days.length; i++) {
      final day = days[i];
      final count = orders.where((o) {
        final d = o.orderDate;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      }).length;

      total += count;
      spots.add(FlSpot(i.toDouble(), count.toDouble()));
      bottomTitles.add('${day.day}/${day.month}');
    }

    final (maxY, interval) = _calculateMaxYAndInterval(spots);

    return OrdersChartData(
      spots: spots,
      bottomTitles: bottomTitles,
      maxY: maxY,
      interval: interval,
      bottomTitleInterval: 5.0,
      periodSubtitle: 'آخر 30 يوم (إجمالي: $total طلب)',
      totalPeriodOrders: total,
    );
  }

  OrdersChartData _calculateYearOrdersData(List<OrderEntity> orders) {
    final now = DateTime.now();
    const arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    final spots = <FlSpot>[];
    final bottomTitles = <String>[];
    int total = 0;

    for (int m = 1; m <= 12; m++) {
      final count = orders.where((o) {
        final d = o.orderDate;
        return d.year == now.year && d.month == m;
      }).length;

      total += count;
      spots.add(FlSpot((m - 1).toDouble(), count.toDouble()));
      bottomTitles.add(arabicMonths[m - 1]);
    }

    final (maxY, interval) = _calculateMaxYAndInterval(spots);

    return OrdersChartData(
      spots: spots,
      bottomTitles: bottomTitles,
      maxY: maxY,
      interval: interval,
      bottomTitleInterval: 1.0,
      periodSubtitle: 'عام ${now.year} (إجمالي: $total طلب)',
      totalPeriodOrders: total,
    );
  }

  (double, double) _calculateMaxYAndInterval(List<FlSpot> spots) {
    double maxCount =
        spots.isEmpty ? 0.0 : spots.map((s) => s.y).reduce(math.max);
    double maxY;
    double interval;

    if (maxCount <= 4) {
      maxY = 4.0;
      interval = 1.0;
    } else if (maxCount <= 8) {
      maxY = 8.0;
      interval = 2.0;
    } else if (maxCount <= 20) {
      maxY = ((maxCount + 3) ~/ 4 * 4).toDouble();
      interval = maxY / 4;
    } else {
      final step = (maxCount / 4).ceil();
      final roundedStep = step <= 10 ? step : ((step + 4) ~/ 5 * 5);
      maxY = (roundedStep * 4).toDouble();
      interval = roundedStep.toDouble();
    }

    return (maxY, interval);
  }
}

