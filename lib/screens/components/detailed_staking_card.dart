import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/models/staking_detail.dart';
import '../../../config/app_colors.dart';

class DetailedStakingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String mainValue;
  final String? mainLabel;
  final List<StakingDetail> details;
  final Color accentColor;
  final IconData? icon;
  final LinearGradient? backgroundGradient;

  const DetailedStakingCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.mainValue,
    this.mainLabel,
    required this.details,
    required this.accentColor,
    this.icon,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient:
            backgroundGradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: 0.1),
                accentColor.withValues(alpha: 0.03),
              ],
            ),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: AppColorsExtended.cardShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColorsExtended.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColorsExtended.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Main value section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mainLabel != null)
                  Text(
                    mainLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColorsExtended.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Text(
                  mainValue,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Details grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: details.length,
            itemBuilder: (context, index) {
              final detail = details[index];
              return _buildDetailItem(detail);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(StakingDetail detail) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: detail.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: detail.color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            detail.label,
            style: TextStyle(
              fontSize: 11,
              color: AppColorsExtended.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            detail.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: detail.color,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

