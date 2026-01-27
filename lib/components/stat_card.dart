import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/components/trend_card.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import '../config/theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool showTrendIcon;
  final bool isTrendPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
    this.showTrendIcon = false,
    this.isTrendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final ResponsiveLayout responsive = context.responsive;
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.all(responsive.isMobile ? 12 : 20),
        opacity: 0.08,
        blur: 20,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), color.withOpacity(0.08)],
        ),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, 
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          fontSize: responsive.isMobile ? 12 : 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: responsive.isMobile ? 6 : 8),
                      
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            value,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              fontSize: responsive.isMobile ? 18 : 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.isMobile ? 6 : 8),
                _buildIcon(responsive),
              ],
            ),
            
            if (subtitle != null || showTrendIcon) ...[
              SizedBox(height: responsive.isMobile ? 6 : 8),
              Divider(color: Colors.white.withOpacity(0.1), height: 1),
              SizedBox(height: responsive.isMobile ? 6 : 8),
            ],
            
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: responsive.isMobile ? 10 : 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
                
            if (showTrendIcon) ...[
              SizedBox(height: responsive.isMobile ? 4 : 6),
              TrendCard(isTrendPositive: isTrendPositive),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ResponsiveLayout responsive) {
    final iconSize = responsive.isMobile ? 18 : 22;
    final padding = responsive.isMobile ? 8 : 12;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Icon(icon, color: color, size: iconSize), 
    );
  }
}