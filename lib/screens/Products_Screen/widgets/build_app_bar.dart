
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/build_add_button.dart';

PreferredSizeWidget buildAppBar(
  BuildContext context,
  ProductsController controller,
  var responsive,
) {
  return AppBar(
    elevation: 0,
    title: Text(
      'إدارة المنتجات',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: responsive.getTitleFontSize() + 2,
      ),
    ),
    centerTitle: true,
    actions: [
      buildAddButton(context, controller, responsive),
      SizedBox(width: responsive.itemSpacing),
    ],
  );
}

