import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class CustomDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final VoidCallback? onRefresh;

  const CustomDashboardAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // جلب التجاوب تلقائياً من الـ context لتقليل تمرير الباراميترز
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: elevation,
      backgroundColor: Colors.transparent, // لجعل الـ GlassContainer يظهر خلفه
      centerTitle: centerTitle,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20, // يمكن ربطها بـ responsiveLayout لاحقاً
          color: isDark ? Colors.white : AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        if (onRefresh != null)
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث البيانات',
          ),
        ...?actions, // دمج الـ Actions الإضافية إذا وجدت
        const SizedBox(width: 8),
      ],
      // إضافة خط سفلي ناعم بدلاً من الـ Elevation
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}