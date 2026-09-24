import 'package:fl_chart/fl_chart.dart';

class OrdersChartData {
  final List<FlSpot> spots;
  final List<String> bottomTitles;
  final double maxY;
  final double interval;
  final double bottomTitleInterval;
  final String periodSubtitle;
  final int totalPeriodOrders;

  const OrdersChartData({
    required this.spots,
    required this.bottomTitles,
    required this.maxY,
    required this.interval,
    required this.bottomTitleInterval,
    required this.periodSubtitle,
    required this.totalPeriodOrders,
  });
}
