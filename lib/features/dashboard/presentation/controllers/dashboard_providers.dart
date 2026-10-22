import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_providers.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/controllers/users_providers.dart';
import '../models/orders_chart_data.dart';

/// موفر مستودع لوحة التحكم الرئيسي
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    orderRepository: ref.watch(orderRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});

/// موفر حالة استخدام جلب بيانات لوحة التحكم
final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.watch(dashboardRepositoryProvider));
});

const List<Map<String, String>> dashboardPeriodItems = [
  {'id': 'week', 'name': 'هذا الأسبوع'},
  {'id': 'month', 'name': 'هذا الشهر'},
  {'id': 'year', 'name': 'هذا العام'},
];

/// موفر فترة العرض المحددة (week / month / year)
class DashboardPeriodNotifier extends Notifier<String> {
  @override
  String build() => 'week';

  void setPeriod(String period) => state = period;
}

final dashboardPeriodProvider =
    NotifierProvider<DashboardPeriodNotifier, String>(DashboardPeriodNotifier.new);

/// موفر حالة لوحة التحكم الرئيسي عبر [AsyncNotifier] مع إدارة الإلغاء ومنع تسريب الموارد
class DashboardStatsNotifier extends AsyncNotifier<DashboardStatsEntity> {
  CancelToken? _cancelToken;

  @override
  Future<DashboardStatsEntity> build() async {
    _cancelToken?.cancel('Dashboard notifier disposed or reinitialized');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    ref.onDispose(() {
      cancelToken.cancel('Dashboard page closed');
    });

    final useCase = ref.watch(getDashboardDataUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    return result.fold(
      (failure) => throw failure,
      (stats) => stats,
    );
  }

  /// إعادة تحميل بيانات لوحة التحكم
  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    _cancelToken?.cancel('User requested refresh');
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final useCase = ref.read(getDashboardDataUseCaseProvider);
    final result = await useCase(cancelToken: cancelToken);

    if (ref.exists(dashboardStatsNotifierProvider)) {
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (stats) => AsyncValue.data(stats),
      );
    }
  }
}

final dashboardStatsNotifierProvider =
    AsyncNotifierProvider<DashboardStatsNotifier, DashboardStatsEntity>(
  DashboardStatsNotifier.new,
);

/// موفر بيانات الرسم البياني للطلبات بناءً على الفترة المحددة
final ordersChartDataProvider = Provider<OrdersChartData>((ref) {
  final stats = ref.watch(dashboardStatsNotifierProvider).value ??
      DashboardStatsEntity.initial();
  final period = ref.watch(dashboardPeriodProvider);
  return _calculateOrdersChartData(stats.orders, period);
});

/// موفر بيانات مؤشر الاتجاه لكل حالة طلب
final statusTrendDataProvider =
    Provider.family<IndicatorTrendData, OrderStatus>((ref, status) {
  final stats = ref.watch(dashboardStatsNotifierProvider).value ??
      DashboardStatsEntity.initial();
  final period = ref.watch(dashboardPeriodProvider);
  return _calculateStatusTrendData(stats.orders, status, period);
});

OrdersChartData _calculateOrdersChartData(
  List<OrderEntity> orders,
  String period,
) {
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
    bottomTitles.add(arabicDays[(day.weekday - 1) % 7]);
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

IndicatorTrendData _calculateStatusTrendData(
  List<OrderEntity> orders,
  OrderStatus status,
  String period,
) {
  switch (period) {
    case 'month':
      return _calculateStatusMonthData(orders, status);
    case 'year':
      return _calculateStatusYearData(orders, status);
    case 'week':
    default:
      return _calculateStatusWeekData(orders, status);
  }
}

IndicatorTrendData _calculateStatusWeekData(
  List<OrderEntity> orders,
  OrderStatus status,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final currentDays =
      List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
  final previousDays =
      List.generate(7, (i) => today.subtract(Duration(days: 13 - i)));

  final spots = <FlSpot>[];
  int currentTotal = 0;

  for (int i = 0; i < currentDays.length; i++) {
    final day = currentDays[i];
    final count = orders.where((o) {
      return o.status == status &&
          o.orderDate.year == day.year &&
          o.orderDate.month == day.month &&
          o.orderDate.day == day.day;
    }).length;

    currentTotal += count;
    spots.add(FlSpot(i.toDouble(), count.toDouble()));
  }

  int previousTotal = 0;
  for (final day in previousDays) {
    final count = orders.where((o) {
      return o.status == status &&
          o.orderDate.year == day.year &&
          o.orderDate.month == day.month &&
          o.orderDate.day == day.day;
    }).length;
    previousTotal += count;
  }

  final (trend, trendUp) =
      _calculateTrendPercentage(currentTotal, previousTotal);

  return IndicatorTrendData(
    spots: spots,
    trend: trend,
    trendUp: trendUp,
  );
}

IndicatorTrendData _calculateStatusMonthData(
  List<OrderEntity> orders,
  OrderStatus status,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final currentDays =
      List.generate(30, (i) => today.subtract(Duration(days: 29 - i)));
  final previousDays =
      List.generate(30, (i) => today.subtract(Duration(days: 59 - i)));

  final spots = <FlSpot>[];
  int currentTotal = 0;

  for (int i = 0; i < currentDays.length; i++) {
    final day = currentDays[i];
    final count = orders.where((o) {
      return o.status == status &&
          o.orderDate.year == day.year &&
          o.orderDate.month == day.month &&
          o.orderDate.day == day.day;
    }).length;

    currentTotal += count;
    spots.add(FlSpot(i.toDouble(), count.toDouble()));
  }

  int previousTotal = 0;
  for (final day in previousDays) {
    final count = orders.where((o) {
      return o.status == status &&
          o.orderDate.year == day.year &&
          o.orderDate.month == day.month &&
          o.orderDate.day == day.day;
    }).length;
    previousTotal += count;
  }

  final (trend, trendUp) =
      _calculateTrendPercentage(currentTotal, previousTotal);

  return IndicatorTrendData(
    spots: spots,
    trend: trend,
    trendUp: trendUp,
  );
}

IndicatorTrendData _calculateStatusYearData(
  List<OrderEntity> orders,
  OrderStatus status,
) {
  final now = DateTime.now();
  final spots = <FlSpot>[];
  int currentTotal = 0;

  for (int m = 1; m <= 12; m++) {
    final count = orders.where((o) {
      return o.status == status &&
          o.orderDate.year == now.year &&
          o.orderDate.month == m;
    }).length;

    currentTotal += count;
    spots.add(FlSpot((m - 1).toDouble(), count.toDouble()));
  }

  int previousTotal = orders.where((o) {
    return o.status == status && o.orderDate.year == (now.year - 1);
  }).length;

  final (trend, trendUp) =
      _calculateTrendPercentage(currentTotal, previousTotal);

  return IndicatorTrendData(
    spots: spots,
    trend: trend,
    trendUp: trendUp,
  );
}

(String, bool) _calculateTrendPercentage(int current, int previous) {
  if (previous == 0) {
    if (current == 0) {
      return ('0%', true);
    }
    return ('+100%', true);
  }

  final diff = current - previous;
  final percent = ((diff / previous) * 100).round();

  if (percent >= 0) {
    return ('+$percent%', true);
  } else {
    return ('$percent%', false);
  }
}
