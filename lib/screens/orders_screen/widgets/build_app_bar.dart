
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';

PreferredSizeWidget buildAppBar( OrdersController controller, ResponsiveLayout responsive) {
    return AppBar(
      title: Text(
        'إدارة الطلبات',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: responsive.getTitleFontSize() + 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => controller.fetchOrders(),
          icon: const Icon(Icons.refresh),
          tooltip: 'تحديث',
        ),
        const SizedBox(width: 8),
      ],
    );
  }
