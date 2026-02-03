
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';

Widget buildEnhancedHeader(OrdersController controller) {
    return Builder(
      builder: (context) {
        final responsive = ResponsiveLayout(context);
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
            vertical: 8,
          ),
          child: Column(
            children: [
              // Title with Counter Badge
              Obx(() {
                final totalCount = controller.filteredOrders.length;
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: responsive.isMobile ? 24 : 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إدارة الطلبات',
                            style: TextStyle(
                              fontSize: responsive.isMobile ? 18 : 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'عرض وإدارة جميع الطلبات',
                            style: TextStyle(
                              fontSize: responsive.isMobile ? 12 : 13,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Animated Counter Badge
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: totalCount),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'طلب',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              // Search Bar
              CustomSearchBar(
                hintText: 'ابحث عن الطلبات بالرقم أو اسم العميل...',
                padding: EdgeInsets.zero,
                onSearch: (value) => controller.onSearchChanged(value),
              ),

              const SizedBox(height: 12),

              // Status Filter Chips
              Obx(
                () => HorizontalChipsSelector(
                  items: controller.statusItems,
                  selectedId: controller.selectedStatusId.value,
                  onSelect: (id) => controller.selectedStatusId.value = id,
                  showAllOption: true,
                  allLabel: 'جميع الطلبات',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
