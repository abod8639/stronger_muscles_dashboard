import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_nav_item.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';

class Sidebar extends StatelessWidget {
  final bool isDrawer;
  const Sidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final NavigationController controller = Get.find<NavigationController>();
    final authService = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    final userRole = authService?.getUserRole() ?? 'admin';
    final isSuperOrAdmin = userRole == 'super_admin' || userRole == 'admin';
    final isSupport = userRole == 'customer_support';

    return Container(
      width: 280,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // --- SECTION: LOGO ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.flash_on_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'STRONGER',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 10),

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

                    const SizedBox(height: 20),
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

              // --- SECTION: USER PROFILE ---
              const _SidebarUserProfile(),
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 12),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
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
    final authService = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    final adminName = authService?.getUserName() ?? 'Dexter';
    final adminRole = authService?.getUserRole() ?? 'admin';

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
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
          const SizedBox(width: 12),
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
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            color: colorScheme.error,
            tooltip: 'Logout',
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
