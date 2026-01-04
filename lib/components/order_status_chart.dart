import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'enhanced_status_chart.dart';

class OrderStatusChart extends StatelessWidget {
  final int pending;
  final int processing;
  final int shipped;
  final int delivered;
  final int cancelled;

  const OrderStatusChart({
    super.key,
    required this.pending,
    required this.processing,
    required this.shipped,
    required this.delivered,
    required this.cancelled,
  });

  @override
  Widget build(BuildContext context) {
    final total = pending + processing + shipped + delivered + cancelled;

    return EnhancedStatusChart(
      title: 'توزيع حالات الطلبات',
      items: [
        StatusChartItem(
          label: 'معلقة',
          count: pending,
          total: total,
          color: AppColors.pending,
        ),
        StatusChartItem(
          label: 'تحت المعالجة',
          count: processing,
          total: total,
          color: AppColors.processing,
        ),
        StatusChartItem(
          label: 'مرسلة',
          count: shipped,
          total: total,
          color: AppColors.shipped,
        ),
        StatusChartItem(
          label: 'تم التسليم',
          count: delivered,
          total: total,
          color: AppColors.delivered,
        ),
        StatusChartItem(
          label: 'ملغاة',
          count: cancelled,
          total: total,
          color: AppColors.cancelled,
        ),
      ],
    );
  }
}

