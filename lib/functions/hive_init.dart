import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/data/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/data/models/user_address.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(OrderItemModelAdapter());
  Hive.registerAdapter(OrderStatusAdapter());
  Hive.registerAdapter(PaymentStatusAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(DashboardUserAdapter());
  Hive.registerAdapter(UserAddressAdapter());
  Hive.registerAdapter(UserModelAdapter());

  await Hive.openBox<DashboardUser>('dashboardUsers');
  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<OrderModel>('orders');
  await Hive.openBox<UserAddress>('addresses');
  await Hive.openBox<UserModel>('users');
}
