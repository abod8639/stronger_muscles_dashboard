import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;
  final bool showStatus;
  final bool isConnected;
  final VoidCallback? onPressed;
  final bool centerTitle;
  final IconData icon;
  final Color? surfaceTintColor;
  final Widget? leading;

  const BaseAppBar({
    super.key,
    required this.title,
    this.extraActions,
    this.showStatus = false,
    this.isConnected = true,
    this.onPressed,
    this.centerTitle = true,
    this.icon = Icons.refresh_rounded,
    this.surfaceTintColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && !canPop && !isDesktop) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.menu_rounded),
        tooltip: 'القائمة الرئيسية',
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    }

    return AppBar(
      leading: effectiveLeading,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          height: 1.0,
        ),
      ),
      actions: [
        // 1. مؤشر حالة الاتصال (يظهر فقط إذا تم تفعيل showStatus)
        if (showStatus) _buildConnectionStatus(),

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
  Widget _buildConnectionStatus() {
    final statusColor = isConnected ? AppColors.success : AppColors.error;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusPulseDot(color: statusColor),
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
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StatusPulseDot extends StatefulWidget {
  final Color color;
  const _StatusPulseDot({required this.color});

  @override
  State<_StatusPulseDot> createState() => _StatusPulseDotState();
}

class _StatusPulseDotState extends State<_StatusPulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: 0.3 + (_anim.value * 0.4),
                ),
                blurRadius: 4 + (_anim.value * 4),
                spreadRadius: _anim.value * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
