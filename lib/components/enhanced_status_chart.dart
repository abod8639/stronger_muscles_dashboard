import 'package:flutter/material.dart';
import '../config/theme.dart';

class GradientProgressBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const GradientProgressBar({
    super.key,
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
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: (percentage / 100) * double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                if (percentage > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EnhancedStatusChart extends StatefulWidget {
  final String title;
  final List<StatusChartItem> items;
  final EdgeInsets padding;

  const EnhancedStatusChart({
    super.key,
    required this.title,
    required this.items,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<EnhancedStatusChart> createState() => _EnhancedStatusChartState();
}

class _EnhancedStatusChartState extends State<EnhancedStatusChart>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800 + (index * 100)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    for (var controller in _controllers) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.padding.left,
            top: widget.padding.top,
            right: widget.padding.right,
          ),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Padding(
          padding: widget.padding,
          child: Column(
            children: List.generate(
              widget.items.length,
              (index) {
                final item = widget.items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < widget.items.length - 1 ? 16 : 0,
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      _animations[index],
                    ),
                    child: GradientProgressBar(
                      label: item.label,
                      count: item.count,
                      total: item.total,
                      color: item.color,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StatusChartItem {
  final String label;
  final int count;
  final int total;
  final Color color;

  StatusChartItem({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });
}
