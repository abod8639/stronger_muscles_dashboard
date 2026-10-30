import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// المصدر الوحيد لعرض أنواع الإشعارات (التسمية، الأيقونة، اللون)
/// يُستخدم في بطاقة الإشعار وشرائح التصفية ونافذة الإرسال
enum NotificationTypeUi {
  general('general', 'عام', Icons.campaign_rounded, AppColors.success),
  promo('promo', 'إعلان / عرض', Icons.local_offer_rounded, AppColors.warning),
  order('order', 'حالة طلب', Icons.local_shipping_rounded, AppColors.info),
  system('system', 'نظام / أمان', Icons.security_rounded, AppColors.error),
  support('support', 'دعم فني', Icons.support_agent_rounded, Color(0xFFA855F7));

  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const NotificationTypeUi(this.id, this.label, this.icon, this.color);

  static NotificationTypeUi of(String id) {
    final normalized = id.toLowerCase();
    if (normalized == 'support_ticket' || normalized == 'ticket') {
      return support;
    }
    return values.firstWhere(
      (t) => t.id == normalized,
      orElse: () => general,
    );
  }
}
