import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import '../controllers/users_controller.dart';
import 'widgets/buildUserCard.dart';
import 'widgets/build_stats_header.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      appBar: BaseAppBar(
        title: 'المستخدمون',
        onPressed: controller.fetchUsersData,
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
            TopSection(
              children: [
                CustomSearchBar(
                  hintText: 'ابحث عن المستخدم بالاسم أو البريد الإلكتروني...',
                  padding: responsive.defaultPadding,
                  onSearch: (value) => controller.onSearchChanged(value),
                ),
                buildStatsHeader(),
              ],
            ),
            Expanded(
              child: controller.filteredUsers.isEmpty
                  ? EnhancedErrorWidget(
                      title: 'لا يوجد مستخدمين',
                      message: controller.searchQuery.isEmpty
                          ? 'لم يتم العثور على أي مستخدمين مسجلين'
                          : 'لا توجد نتائج لبحثك: "${controller.searchQuery.value}"',
                      icon: Icons.people_outline,
                      onRetry: controller.fetchUsersData,
                    )
                  : MyRefreshIndicator(
                      onRefresh: controller.fetchUsersData,
                      child: ListView.builder(
                        padding: responsive.defaultPadding,
                        itemCount: controller.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = controller.filteredUsers[index];
                          return buildUserCard(user);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
