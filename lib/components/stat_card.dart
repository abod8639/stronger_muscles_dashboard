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
        padding: EdgeInsets.all(responsive.isMobile ? 5 : 16), // إضافة padding داخلي ثابت
        opacity: 0.05,
        blur: 15,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        child: Padding(
          padding: EdgeInsets.all(responsive.isMobile ? 5 : 16), // إضافة padding داخلي ثابت
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // محاذاة الأيقونة مع أعلى النص
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith( // استخدام حجم أصغر قليلاً للعنوان
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        // استخدام FittedBox لمنع خروج الأرقام الطويلة عن الحواف
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, color],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              value,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // الأيقونة بحجم مرن
                  _buildIcon(),
                ],
              ),
              
              if (subtitle != null || showTrendIcon) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),
              ],
              
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
              if (showTrendIcon) ...[
                const SizedBox(height: 8),
                TrendCard(isTrendPositive: isTrendPositive),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: Colors.white, size: 20), // تصغير الأيقونة قليلاً
    );
  }
}