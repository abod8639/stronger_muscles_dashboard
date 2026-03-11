import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/utils/components/base_app_bar.dart';
import '../../../../core/utils/components/custom_search_bar.dart';
import '../../../../core/utils/components/enhanced_error_widget.dart';
import '../../../../core/utils/components/enhanced_loading_widget.dart';
import '../../../../core/utils/components/my_refreshIndicator.dart';
import '../../../../core/utils/components/top_section.dart';
import '../controllers/users_controller.dart';
import '../widgets/user_card.dart';
import '../widgets/users_stats_header.dart';
import '../../../../config/responsive.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
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
            // Search Bar & Stats
            TopSection(
              children: [
                CustomSearchBar(
                  hintText: 'ابحث عن المستخدم بالاسم أو البريد الإلكتروني...',
                  padding: responsive.defaultPadding,
                  onSearch: (value) => controller.onSearchChanged(value),
                ),
                const UsersStatsHeader(),
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
                  : MyRefreshIndicator(
                      onRefresh: controller.fetchUsersStats,
                      child: ListView.builder(
                        padding: responsive.defaultPadding,
                        itemCount: controller.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = controller.filteredUsers[index];
                          return UserCard(user: user);
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
