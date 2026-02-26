import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_nav_item.dart';

class Sidebar extends StatelessWidget {
  final bool isDrawer;
  const Sidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return Container(
      width: 280, // تقليل العرض قليلاً ليبدو أكثر رشاقة
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: GlassContainer(
        opacity: 0.08, // زيادة طفيفة للتباين
        blur: 25,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // --- SECTION: LOGO ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flash_on_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'STRONGER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white10, indent: 20, endIndent: 20),
            const SizedBox(height: 10),

            // --- SECTION: NAVIGATION ---
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _sectionTitle('MAIN MENU'),
                  buildNavItem(
                    isDrawer,
                    controller,
                    0,
                    Icons.dashboard_outlined,
                    Icons.dashboard_rounded,
                    'Dashboard',
                  ),
                  buildNavItem(
                    isDrawer,
                    controller,
                    2,
                    Icons.inventory_2_outlined,
                    Icons.inventory_2_rounded,
                    'Products',
                  ),
                  buildNavItem(
                    isDrawer,
                    controller,
                    4,
                    Icons.people_outline,
                    Icons.people_rounded,
                    'Users',
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('MANAGEMENT'),
                  buildNavItem(
                    isDrawer,
                    controller,
                    1,
                    Icons.category_outlined,
                    Icons.category_rounded,
                    'Categories',
                  ),
                  buildNavItem(
                    isDrawer,
                    controller,
                    3,
                    Icons.local_shipping_outlined,
                    Icons.local_shipping_rounded,
                    'Orders',
                  ),
                  buildNavItem(
                    isDrawer,
                    controller,
                    5,
                    Icons.settings_outlined,
                    Icons.settings_rounded,
                    'Settings',
                  ),
                ],
              ),
            ),

            // --- SECTION: USER PROFILE ---
            _buildUserProfile(),
          ],
        ),
      ),
    );
  }

  // عنوان جانبي صغير لتنظيم القائمة
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5), // المسافة بين الإطار والصورة
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // إطار متدرج يعطي مظهر "النيون" الهادئ
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black, // خلفية سوداء تفصل بين الإطار والصورة
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://avatars.githubusercontent.com/u/108903062?v=4',
                  cacheManager: CustomCacheManager.instance,
                  width: 36, // ضعف الـ radius (18 * 2)
                  height: 36,
                  fit: BoxFit.cover,
                  // تأثير التحميل السلس
                  placeholder: (context, url) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  // في حال فشل التحميل تظهر أيقونة مستخدم
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[900],
                    child: const Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 20,
                    ),
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
                const Text(
                  'Dexter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Admin Account',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent.withValues(alpha: 0.8),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
