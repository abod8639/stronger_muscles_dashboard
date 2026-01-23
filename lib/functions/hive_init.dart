
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());

  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<OrderModel>('orders');

}