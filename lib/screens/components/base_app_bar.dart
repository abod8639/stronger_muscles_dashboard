import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;
  final bool showStatus; // لتحديد ما إذا كنا نريد إظهار حالة الاتصال
  final VoidCallback? onPressed;
  final bool centerTitle;
  final IconData icon;
  final Color? surfaceTintColor;

  const BaseAppBar({
    super.key,
    required this.title,
    this.extraActions,
    this.showStatus = false,
    this.onPressed,
    this.centerTitle = true,
    this.icon = Icons.refresh_rounded,
    this.surfaceTintColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // نستخدم find بدلاً من put لضمان عدم إنشاء نسخة جديدة إذا كان موجوداً
    final DashboardController statusController =
        Get.find<DashboardController>();

    return AppBar(
      // foregroundColor: Colors.white,
      // shadowColor:shadowColor?? Colors.transparent,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textMuted,
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        // 1. مؤشر حالة الاتصال (يظهر فقط إذا تم تفعيل showStatus)
        if (showStatus) _buildConnectionStatus(statusController),

        // 2. زر التحديث (يظهر فقط إذا تم تمرير دالة onRefresh)
        if (onPressed != null)
          IconButton(onPressed: onPressed, icon: Icon(icon), tooltip: 'تحديث'),

        // 3. أي أزرار إضافية مخصصة للشاشة
        ...?extraActions,

        const SizedBox(width: 8),
      ],
    );
  }

  // مكوّن حالة الاتصال المنفصل
  Widget _buildConnectionStatus(DashboardController controller) {
    return Obx(() {
      final isConnected = controller.isConnected.value;
      final statusColor = isConnected ? AppColors.success : AppColors.error;

      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: statusColor.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusPulseDot(color: statusColor), // النقطة النابضة
              const SizedBox(width: 6),
              Text(
                isConnected ? 'متصل' : 'قطع اتصال',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// إضافة تأثير نبضي بسيط للنقطة لجعل الواجهة حيوية
class _StatusPulseDot extends StatefulWidget {
  final Color color;
  const _StatusPulseDot({required this.color});

  @override
  State<_StatusPulseDot> createState() => _StatusPulseDotState();
}

class _StatusPulseDotState extends State<_StatusPulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(CurveTween(curve: Curves.easeInOut)),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
