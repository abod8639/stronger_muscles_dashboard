import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final NumberFormat _priceFormat = NumberFormat('#,##0.00');

/// تنسيق موحد للمبالغ: فواصل الآلاف ورقمان عشريان متبوعان برمز العملة
String formatPrice(double amount, String currency) =>
    '${_priceFormat.format(amount)} $currency';

/// نص سعر موحد: المبلغ بخط بارز ورمز العملة بخط أصغر
/// العملة تُمرَّر من الشاشة (مثلاً من إعدادات المتجر) حتى تبقى core مستقلة عن الميزات
class PriceText extends StatelessWidget {
  final double amount;
  final String currency;
  final TextStyle? style;
  final Color? color;

  const PriceText({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.onSurface;
    final amountStyle = (style ?? theme.textTheme.titleMedium)?.copyWith(
      color: effectiveColor,
      fontWeight: FontWeight.w800,
    );

    return Text.rich(
      TextSpan(
        text: _priceFormat.format(amount),
        style: amountStyle,
        children: [
          TextSpan(
            text: ' $currency',
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
