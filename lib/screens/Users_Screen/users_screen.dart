
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';
import 'package:stronger_muscles_dashboard/components/index.dart';
import 'package:stronger_muscles_dashboard/screens/Users_Screen/widgets/buildUserCard.dart';
import 'package:stronger_muscles_dashboard/screens/Users_Screen/widgets/build_stats_header.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UsersController());
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let MainNavigationScreen handle background
      appBar: AppBar(
        title: Text(
          'المستخدمون',
          style: TextStyle(
            fontSize: responsive.getTitleFontSize(),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: controller.fetchUsersStats,
            icon: Icon(Icons.refresh, size: responsive.iconSize),
            tooltip: 'تحديث',
          ),
          SizedBox(width: responsive.itemSpacing),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.filteredUsers.isEmpty) {
          return const EnhancedLoadingWidget(message: 'جاري تحميل بيانات المستخدمين...');
        }

        return Column(
          children: [
            // Search Bar
            Padding(
              padding: responsive.defaultPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                      ),
                      child: TextField(
                        onChanged: controller.onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'البحث باسم المستخدم أو البريد الإلكتروني...',
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ملخص الإحصائيات
            buildStatsHeader( controller),
            
            // قائمة المستخدمين
            Expanded(
              child: controller.filteredUsers.isEmpty
                  ? EnhancedErrorWidget(
                      title: 'لا يوجد مستخدمين',
                      message: controller.searchQuery.isEmpty 
                          ? 'لم يتم العثور على أي مستخدمين مسجلين'
                          : 'لا توجد نتائج لبحثك: "${controller.searchQuery.value}"',
                      icon: Icons.people_outline,
                      onRetry: controller.fetchUsersStats,
                    )
                  : ListView.builder(
                      padding: responsive.defaultPadding,
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        return buildUserCard( user);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
