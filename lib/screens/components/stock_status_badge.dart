import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class StockStatusBadge extends StatelessWidget {
  final int quantity;

  const StockStatusBadge({super.key, required this.quantity});

  Color _getStockColor() {
    if (quantity <= 0) {
      return AppColors.error;
    } else if (quantity <= 10) {
      return AppColors.warning;
    } else {
      return AppColors.success;
    }
  }

  String _getStockLabel() {
    if (quantity <= 0) {
      return 'OUT OF STOCK';
    } else if (quantity <= 10) {
      return 'LOW STOCK';
    } else {
      return 'IN STOCK';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStockColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getStockLabel(),
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
