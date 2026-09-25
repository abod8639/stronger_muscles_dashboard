import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import 'user_info_row.dart';

/// بطاقة عرض تفاصيل المستخدم بتصميم Neumorphism / Soft UI
/// متناسقة ديناميكياً مع سمة التطبيق وتدعم الوضعين الفاتح والداكن بانتقالات وتأثيرات بصرية ثلاثية الأبعاد ناعمة.
class UserCard extends StatefulWidget {
  final UserEntity user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderRadius = BorderRadius.circular(22);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.008 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered || _isExpanded ? 0.05 : 0.03)!,
                      Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered || _isExpanded ? 0.05 : 0.09)!,
                    ]
                  : [
                      Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered || _isExpanded ? 0.75 : 0.65)!,
                      Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered || _isExpanded ? 0.01 : 0.035)!,
                    ],
            ),
            boxShadow: [
              // الظل السفلي الناعم (Drop Shadow)
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: _isHovered || _isExpanded ? 0.65 : 0.55)
                    : const Color(0xFFA3B1C6).withValues(alpha: _isHovered || _isExpanded ? 0.55 : 0.42),
                offset: (_isHovered || _isExpanded) ? const Offset(6, 8) : const Offset(4, 6),
                blurRadius: (_isHovered || _isExpanded) ? 18 : 14,
                spreadRadius: 0,
              ),
              // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: _isHovered || _isExpanded ? 0.06 : 0.04)
                    : Colors.white.withValues(alpha: _isHovered || _isExpanded ? 1.0 : 0.95),
                offset: (_isHovered || _isExpanded) ? const Offset(-4, -4) : const Offset(-3, -3),
                blurRadius: (_isHovered || _isExpanded) ? 14 : 10,
                spreadRadius: 0,
              ),
              // وهج ناعم بلون السمة عند التحويم أو الفتح
              if (_isHovered || _isExpanded)
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: isDark ? 0.10 : 0.12),
                  offset: const Offset(0, 4),
                  blurRadius: 16,
                  spreadRadius: -2,
                ),
            ],
            border: Border.all(
              color: isDark
                  ? (_isHovered || _isExpanded
                      ? colorScheme.primary.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.06))
                  : (_isHovered || _isExpanded
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.85)),
              width: (_isHovered || _isExpanded) ? 1.3 : 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: Theme(
              data: theme.copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: const Border(),
                collapsedShape: const Border(),
                iconColor: colorScheme.primary,
                collapsedIconColor: colorScheme.onSurfaceVariant,
                onExpansionChanged: (expanded) {
                  setState(() => _isExpanded = expanded);
                },
                leading: _buildNeumorphicAvatar(context, isDark, colorScheme),
                title: Text(
                  widget.user.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.user.email != null && widget.user.email!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            widget.user.email!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          _buildOrdersCountChip(context, isDark, colorScheme),
                          const SizedBox(width: 8),
                          _buildStatusBadge(context, isDark, colorScheme),
                        ],
                      ),
                    ],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNeumorphicDivider(isDark),
                        const SizedBox(height: 12),
                        UserInfoRow(
                          label: 'الدور',
                          value: widget.user.role,
                          isDark: isDark,
                        ),
                        if (widget.user.phoneNumber != null && widget.user.phoneNumber!.isNotEmpty)
                          UserInfoRow(
                            label: 'رقم الهاتف',
                            value: widget.user.phoneNumber!,
                            isDark: isDark,
                          ),
                        UserInfoRow(
                          label: 'إجمالي المشتريات',
                          value: '${widget.user.totalSpent} LE',
                          isDark: isDark,
                        ),
                        if (widget.user.lastLogin != null)
                          UserInfoRow(
                            label: 'آخر دخول',
                            value: widget.user.lastLogin.toString().split('.')[0],
                            isDark: isDark,
                          ),
                        if (widget.user.addresses.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            'العناوين المسجلة:',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...widget.user.addresses.map(
                            (addr) => _buildNeumorphicAddressCard(
                              context,
                              isDark,
                              colorScheme,
                              addr,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphicAvatar(BuildContext context, bool isDark, ColorScheme colorScheme) {
    final hasPhoto = widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.06)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.15)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.04)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
            offset: const Offset(2.5, 3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.9),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: hasPhoto
            ? Image.network(
                widget.user.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.person,
                  color: colorScheme.primary,
                  size: 24,
                ),
              )
            : Icon(
                Icons.person,
                color: colorScheme.primary,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildOrdersCountChip(BuildContext context, bool isDark, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : const Color(0xFFA3B1C6).withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 13,
            color: widget.user.ordersCount > 0 ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.user.ordersCount} طلبات',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final isActive = widget.user.isActive;
    final statusColor = isActive ? const Color(0xFF10B981) : colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: isDark ? 0.14 : 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withValues(alpha: isDark ? 0.35 : 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: isDark ? 0.2 : 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'نشط' : 'غير نشط',
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicDivider(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          color: isDark
              ? Colors.black.withValues(alpha: 0.45)
              : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
        ),
        Container(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.9),
        ),
      ],
    );
  }

  Widget _buildNeumorphicAddressCard(
    BuildContext context,
    bool isDark,
    ColorScheme colorScheme,
    dynamic addr,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.12)!
            : Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.45)!,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.2),
            offset: const Offset(1.5, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-1, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${addr.city} - ${addr.street}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (addr.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'الافتراضي',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
