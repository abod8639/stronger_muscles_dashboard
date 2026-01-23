
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(DashboardUserAdapter());
  
  await Hive.openBox<DashboardUser>('dashboardUsers');
  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<OrderModel>('orders');

}