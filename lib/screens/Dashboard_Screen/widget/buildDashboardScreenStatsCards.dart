
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/animated_stat_card.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';

Widget buildDashboardScreenStatsCards() {
  final controller = Get.put(DashboardController());

    return Builder(
      builder: (context) {
    final responsive = context.responsive;
    final spacing = responsive.itemSpacing;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
          ),
          child: isMobile
              ? Column(
                  children: [
                    // صف أول
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الإيرادات',
                            value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                            icon: Icons.trending_up,
                            color: AppColors.primary,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الطلبات',
                            value: controller.totalOrders.value.toString(),
                            icon: Icons.shopping_bag_outlined,
                            color: AppColors.pending,
                            showTrendIcon: true,
                            isTrendPositive: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    // صف ثاني
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المستخدمين',
                            value: controller.totalUsers.value.toString(),
                            icon: Icons.people_outline,
                            color: AppColors.success,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المنتجات',
                            value: controller.totalProducts.value.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: AppColors.warning,
                            showTrendIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : isTablet
                  ? Column(
                      children: [
                        // صف أول - 3 كارتات
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedStatCard(
                                title: 'إجمالي الإيرادات',
                                value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                                icon: Icons.trending_up,
                                color: AppColors.primary,
                                showTrendIcon: true,
                                isTrendPositive: true,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: AnimatedStatCard(
                                title: 'إجمالي الطلبات',
                                value: controller.totalOrders.value.toString(),
                                icon: Icons.shopping_bag_outlined,
                                color: AppColors.pending,
                                showTrendIcon: true,
                                isTrendPositive: false,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: AnimatedStatCard(
                                title: 'إجمالي المستخدمين',
                                value: controller.totalUsers.value.toString(),
                                icon: Icons.people_outline,
                                color: AppColors.success,
                                showTrendIcon: true,
                                isTrendPositive: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        // صف ثاني - كارت واحد
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedStatCard(
                                title: 'إجمالي المنتجات',
                                value: controller.totalProducts.value.toString(),
                                icon: Icons.inventory_2_outlined,
                                color: AppColors.warning,
                                showTrendIcon: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : // سطح المكتب - 4 كارتات في صف واحد
                  Row(
                      children: [
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الإيرادات',
                            value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                            icon: Icons.trending_up,
                            color: AppColors.primary,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الطلبات',
                            value: controller.totalOrders.value.toString(),
                            icon: Icons.shopping_bag_outlined,
                            color: AppColors.pending,
                            showTrendIcon: true,
                            isTrendPositive: false,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المستخدمين',
                            value: controller.totalUsers.value.toString(),
                            icon: Icons.people_outline,
                            color: AppColors.success,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المنتجات',
                            value: controller.totalProducts.value.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: AppColors.warning,
                            showTrendIcon: false,
                          ),
                        ),
                      ],
                    ),
        );
      }
    );
  }

