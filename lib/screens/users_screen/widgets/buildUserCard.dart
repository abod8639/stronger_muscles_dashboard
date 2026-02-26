import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/data/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/screens/users_screen/widgets/build_info_row.dart';

Widget buildUserCard(DashboardUser user) {
  return Builder(
    builder: (context) {
      final responsive = context.responsive;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return GlassContainer(
        margin: const EdgeInsets.only(bottom: 12),
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
              color: isDark ? Colors.white : AppColors.textMuted,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.email != null)
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: responsive.getBodyFontSize() - 2,
                    color: Colors.grey,
                  ),
                ),
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 14,
                    color: user.ordersCount > 0
                        ? AppColors.success
                        : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.ordersCount} طلبات',
                    style: TextStyle(
                      fontSize: responsive.getBodyFontSize() - 2,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: user.isActive
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      user.isActive ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        fontSize: 10,
                        color: user.isActive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow('الدور', user.role, isDark),
                  if (user.phone != null)
                    buildInfoRow('رقم الهاتف', user.phone ?? "00", isDark),
                  buildInfoRow(
                    'إجمالي المشتريات',
                    '${user.totalSpent} LE',
                    isDark,
                  ),
                  if (user.lastLogin != null)
                    buildInfoRow(
                      'آخر دخول',
                      user.lastLogin.toString().split('.')[0],
                      isDark,
                    ),

                  const SizedBox(height: 12),
                  if (user.addresses.isNotEmpty) ...[
                    Text(
                      'العناوين:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...user.addresses.map(
                      (addr) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black12 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('${addr.city} - ${addr.street}'),
                            ),
                            if (addr.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'الافتراضي',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
