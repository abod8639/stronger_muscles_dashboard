import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';

/// عنصر التنقل الجانبي المتوافق مع معايير Material Design 3
class NavItemTile extends StatelessWidget {
  final bool isDrawer;
  final NavigationController controller;
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemTile({
    super.key,
    required this.isDrawer,
    required this.controller,
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.changeIndex(index);
              if (isDrawer) Get.back();
            },
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.secondaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1.0,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// دالة مساعدة للتوافق العكسي
Widget buildNavItem({
  required bool isDrawer,
  required NavigationController controller,
  required int index,
  required IconData icon,
  required IconData activeIcon,
  required String label,
}) {
  return NavItemTile(
    isDrawer: isDrawer,
    controller: controller,
    index: index,
    icon: icon,
    activeIcon: activeIcon,
    label: label,
  );
}
