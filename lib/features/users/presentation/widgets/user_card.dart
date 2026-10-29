import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/components/detail_row.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import '../../domain/entities/user_address_entity.dart';
import '../../domain/entities/user_entity.dart';

/// بطاقة المستخدم: ملخص (الصورة، الاسم، البريد، الطلبات، الحالة) تتوسع لعرض التفاصيل والعناوين
class UserCard extends ConsumerWidget {
  final UserEntity user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = ref.watch(storeCurrencyProvider);

    return SoftSurface(
      child: Theme(
        // إخفاء فواصل ExpansionTile الافتراضية داخل السطح الناعم
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space16,
            vertical: AppDesignTokens.space8,
          ),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.onSurfaceVariant,
          leading: _UserAvatar(photoUrl: user.photoUrl),
          title: Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: AppDesignTokens.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.email?.isNotEmpty ?? false) ...[
                  Text(
                    user.email!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDesignTokens.space6),
                ],
                Wrap(
                  spacing: AppDesignTokens.space8,
                  runSpacing: AppDesignTokens.space4,
                  children: [
                    InfoPill(
                      icon: Icons.shopping_bag_outlined,
                      label: '${user.ordersCount} طلبات',
                      color: user.ordersCount > 0 ? colorScheme.primary : null,
                    ),
                    InfoPill(
                      label: user.isActive ? 'نشط' : 'غير نشط',
                      icon: user.isActive
                          ? Icons.check_circle_rounded
                          : Icons.pause_circle_rounded,
                      color: user.isActive
                          ? AppColors.success
                          : colorScheme.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppDesignTokens.space16,
            0,
            AppDesignTokens.space16,
            AppDesignTokens.space16,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(height: 1, color: colorScheme.outlineVariant),
            DividedColumn(
              children: [
                DetailRow(
                  icon: Icons.badge_outlined,
                  label: 'الدور',
                  value: user.role,
                ),
                if (user.phoneNumber?.isNotEmpty ?? false)
                  DetailRow(
                    icon: Icons.phone_outlined,
                    label: 'رقم الهاتف',
                    value: user.phoneNumber!,
                  ),
                DetailRow(
                  icon: Icons.payments_outlined,
                  label: 'إجمالي المشتريات',
                  value: formatPrice(user.totalSpent, currency),
                ),
                if (user.lastLogin != null)
                  DetailRow(
                    icon: Icons.login_rounded,
                    label: 'آخر دخول',
                    value: DateFormat(
                      'yyyy/MM/dd • hh:mm a',
                    ).format(user.lastLogin!),
                  ),
              ],
            ),
            if (user.addresses.isNotEmpty) ...[
              const SizedBox(height: AppDesignTokens.space14),
              Text(
                'العناوين',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDesignTokens.space10),
              for (final address in user.addresses)
                _AddressTile(address: address),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? photoUrl;

  const _UserAvatar({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fallback = Icon(Icons.person, color: colorScheme.primary, size: 24);

    return SoftSurface(
      compact: true,
      width: 48,
      height: 48,
      borderRadius: AppDesignTokens.radiusCircular,
      child: ClipOval(
        child: (photoUrl?.isNotEmpty ?? false)
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                cacheManager: CustomCacheManager.instance,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              )
            : fallback,
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final UserAddressEntity address;

  const _AddressTile({required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SoftSurface(
      compact: true,
      depth: SoftDepth.inset,
      borderRadius: AppDesignTokens.radiusMedium,
      margin: const EdgeInsets.only(bottom: AppDesignTokens.space8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space12,
        vertical: AppDesignTokens.space10,
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppDesignTokens.space10),
          Expanded(
            child: Text(
              address.fullAddress,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (address.isDefault) ...[
            const SizedBox(width: AppDesignTokens.space8),
            InfoPill(label: 'الافتراضي', color: colorScheme.primary),
          ],
        ],
      ),
    );
  }
}
