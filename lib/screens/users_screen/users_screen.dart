import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';
import 'package:stronger_muscles_dashboard/screens/components/index.dart';
import 'package:stronger_muscles_dashboard/screens/users_screen/widgets/buildUserCard.dart';
import 'package:stronger_muscles_dashboard/screens/users_screen/widgets/build_stats_header.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UsersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Let MainNavigationScreen handle background
      appBar: BaseAppBar(
        title: 'المستخدمون',
        onPressed: controller.fetchUsersStats,
        icon: Icons.refresh_rounded,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.filteredUsers.isEmpty) {
          return const EnhancedLoadingWidget(
            message: 'جاري تحميل بيانات المستخدمين...',
          );
        }

        return Column(
          children: [
            // Search Bar
            TopSection(
              children: [
                CustomSearchBar(
                  hintText: 'ابحث عن المستخدم بالاسم أو البريد الإلكتروني...',
                  padding: responsive.defaultPadding,
                  onSearch: (value) => controller.onSearchChanged(value),
                ),
                // stats header
                buildStatsHeader(),
              ],
            ),
            // users list
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
                        return buildUserCard(user);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
