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


class _StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (count / total) * 100 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class StockStatusChart extends StatelessWidget {
  final int inStock;
  final int lowStock;
  final int outOfStock;

  const StockStatusChart({
    super.key,
    required this.inStock,
    required this.lowStock,
    required this.outOfStock,
  });

  @override
  Widget build(BuildContext context) {
    final total = inStock + lowStock + outOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'حالة المخزون',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _StockIndicator(
                label: 'المتوفرة',
                count: inStock,
                total: total,
                color: AppColors.inStock,
              ),
              const SizedBox(height: 12),
              _StockIndicator(
                label: 'المخزون منخفض',
                count: lowStock,
                total: total,
                color: AppColors.lowStock,
              ),
              const SizedBox(height: 12),
              _StockIndicator(
                label: 'غير متوفرة',
                count: outOfStock,
                total: total,
                color: AppColors.outOfStock,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StockIndicator extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StockIndicator({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.backgroundLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
