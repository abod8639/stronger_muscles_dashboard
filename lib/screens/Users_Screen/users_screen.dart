
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';
import 'package:stronger_muscles_dashboard/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/components/index.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UsersController());
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
        if (controller.isLoading.value) {
          return const EnhancedLoadingWidget(message: 'جاري تحميل بيانات المستخدمين...');
        }

        return Column(
          children: [
            // ملخص الإحصائيات
            _buildStatsHeader(context, controller, responsive),
            
            // قائمة المستخدمين
            Expanded(
              child: controller.users.isEmpty
                  ? EnhancedErrorWidget(
                      title: 'لا يوجد مستخدمين',
                      message: 'لم يتم العثور على أي مستخدمين مسجلين',
                      icon: Icons.people_outline,
                      onRetry: controller.fetchUsersStats,
                    )
                  : ListView.builder(
                      padding: responsive.defaultPadding,
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return _buildUserCard(context, user, responsive, isDark);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatsHeader(BuildContext context, UsersController controller, ResponsiveLayout responsive) {
    return Container(
      padding: responsive.defaultPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people_alt_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي المسجلين',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: responsive.getBodyFontSize(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.totalUsers.value.toString(),
                style: TextStyle(
                  fontSize: responsive.getTitleFontSize(),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, DashboardUser user, ResponsiveLayout responsive, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(8),
        shape: Border.all(color: Colors.transparent),
        collapsedShape: Border.all(color: Colors.transparent),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            image: user.photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(user.photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: user.photoUrl == null
              ? const Icon(Icons.person, color: AppColors.primary)
              : null,
        ),
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.getBodyFontSize() + 1,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 14,
              color: user.hasOrdered ? AppColors.success : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              '${user.ordersCount} طلبات',
              style: TextStyle(
                fontSize: responsive.getBodyFontSize() - 2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        children: [
          if (user.orders.isEmpty)
             Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'لا توجد طلبات سابقة',
                style: TextStyle(color: Colors.grey, fontSize: responsive.getBodyFontSize()),
              ),
            )
          else
            ...user.orders.map((order) => _buildOrderHistoryItem(context, order, isDark)),
        ],
      ),
    );
  }

  Widget _buildOrderHistoryItem(BuildContext context, DashboardOrder order, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade100,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلب #${order.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    order.status,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${order.totalAmount} ر.س',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.danger;
      default:
        return Colors.grey;
    }
  }
}