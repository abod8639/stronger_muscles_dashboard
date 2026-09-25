import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_nav_item.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

/// الشريط الجانبي المصمم بأسلوب Neumorphism / Soft UI
class Sidebar extends StatelessWidget {
  final bool isDrawer;
  const Sidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final NavigationController controller = Get.find<NavigationController>();
    final authService = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    final userRole = authService?.getUserRole() ?? 'admin';
    final isSuperOrAdmin = userRole == 'super_admin' || userRole == 'admin';
    final isSupport = userRole == 'customer_support';

    return Container(
      width: 280,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.035)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                  ]
                : [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.65)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                  ],
          ),
          boxShadow: [
            // الظل السفلي الغامق (Drop Shadow)
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.6)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.45),
              offset: const Offset(7, 8),
              blurRadius: 20,
              spreadRadius: 0,
            ),
            // الظل العلوي الفاتح (Highlight Shadow)
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.white.withValues(alpha: 0.95),
              offset: const Offset(-5, -5),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.8),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            // --- SECTION: LOGO ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.05)!,
                                Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.15)!,
                              ]
                            : [
                                Colors.white,
                                Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.04)!,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.55)
                              : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
                          offset: const Offset(3, 4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.9),
                          offset: const Offset(-2, -2),
                          blurRadius: 6,
                        ),
                      ],
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.flash_on_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'STRONGER',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'DASHBOARD',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            fontSize: 9.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const _NeumorphicDivider(),
            const SizedBox(height: 6),

            // --- SECTION: NAVIGATION ---
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const _SidebarSectionTitle(title: 'MAIN MENU'),
                  NavItemTile(
                    isDrawer: isDrawer,
                    controller: controller,
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                  ),
                  if (!isSupport)
                    NavItemTile(
                      isDrawer: isDrawer,
                      controller: controller,
                      index: 2,
                      icon: Icons.inventory_2_outlined,
                      activeIcon: Icons.inventory_2_rounded,
                      label: 'Products',
                    ),
                  if (isSuperOrAdmin)
                    NavItemTile(
                      isDrawer: isDrawer,
                      controller: controller,
                      index: 3,
                      icon: Icons.add_business_outlined,
                      activeIcon: Icons.add_business_rounded,
                      label: 'Ads',
                    ),
                  if (isSuperOrAdmin)
                    NavItemTile(
                      isDrawer: isDrawer,
                      controller: controller,
                      index: 5,
                      icon: Icons.people_outline,
                      activeIcon: Icons.people_rounded,
                      label: 'Users',
                    ),

                  const SizedBox(height: 14),
                  const _SidebarSectionTitle(title: 'MANAGEMENT'),
                  if (!isSupport)
                    NavItemTile(
                      isDrawer: isDrawer,
                      controller: controller,
                      index: 1,
                      icon: Icons.category_outlined,
                      activeIcon: Icons.category_rounded,
                      label: 'Categories',
                    ),
                  NavItemTile(
                    isDrawer: isDrawer,
                    controller: controller,
                    index: 4,
                    icon: Icons.local_shipping_outlined,
                    activeIcon: Icons.local_shipping_rounded,
                    label: 'Orders',
                  ),
                  if (isSuperOrAdmin)
                    NavItemTile(
                      isDrawer: isDrawer,
                      controller: controller,
                      index: 6,
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings_rounded,
                      label: 'Settings',
                    ),
                ],
              ),
            ),

            const _NeumorphicDivider(),

            // --- SECTION: USER PROFILE ---
            const _SidebarUserProfile(),
          ],
        ),
      ),
    );
  }
}

/// فاصل غائر ومجسم بأسلوب Soft UI
class _NeumorphicDivider extends StatelessWidget {
  const _NeumorphicDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
          ),
          Container(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}

class _SidebarSectionTitle extends StatelessWidget {
  final String title;
  const _SidebarSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8, top: 14),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarUserProfile extends StatelessWidget {
  const _SidebarUserProfile();

  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return 'Super Admin';
      case 'inventory_manager':
        return 'Inventory Manager';
      case 'customer_support':
        return 'Customer Support';
      default:
        return 'Administrator';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final authService = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    final adminName = authService?.getUserName() ?? 'Dexter';
    final adminRole = authService?.getUserRole() ?? 'admin';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(4, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.85),
            offset: const Offset(-3, -3),
            blurRadius: 8,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.75),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar surrounded by a Neumorphic bezel ring
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHighest, Colors.white, 0.08)!,
                        Color.lerp(colorScheme.surfaceContainerHighest, Colors.black, 0.15)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.8),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://avatars.githubusercontent.com/u/108903062?v=4',
                cacheManager: CustomCacheManager.instance,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  adminName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatRole(adminRole),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _NeumorphicLogoutButton(
            onPressed: () {
              if (authService != null) {
                authService.logout();
              } else {
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}

/// زر تسجيل خروج بأسلوب Neumorphism مع استجابة بصرية عند الضغط
class _NeumorphicLogoutButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _NeumorphicLogoutButton({required this.onPressed});

  @override
  State<_NeumorphicLogoutButton> createState() => _NeumorphicLogoutButtonState();
}

class _NeumorphicLogoutButtonState extends State<_NeumorphicLogoutButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Tooltip(
      message: 'Logout',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isPressed
                  ? (isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.15)!,
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                        ]
                      : [
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.06)!,
                          Colors.white,
                        ])
                  : (isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.04)!,
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.1)!,
                        ]
                      : [
                          Colors.white,
                          Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.04)!,
                        ]),
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.5)
                          : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
                      offset: const Offset(2, 3),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.white.withValues(alpha: 0.9),
                      offset: const Offset(-2, -2),
                      blurRadius: 4,
                    ),
                  ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.logout_rounded,
            size: 17,
            color: colorScheme.error.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}
