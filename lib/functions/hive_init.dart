import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/data/models/address_model.dart';
import 'package:stronger_muscles_dashboard/data/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/data/models/user_address.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_adapters.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_model.dart';

void _registerAdapterSafely<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
}

Future<void> hiveInit() async {
  await Hive.initFlutter();

  // Register Core and Domain Model Adapters
  _registerAdapterSafely(AddressModelAdapter());
  _registerAdapterSafely(DashboardUserAdapter());
  _registerAdapterSafely(UserAddressAdapter());
  _registerAdapterSafely(UserModelAdapter());

  // Register Product Adapters
  _registerAdapterSafely(TranslatableStringAdapter());
  _registerAdapterSafely(ProductImageAdapter());
  _registerAdapterSafely(ProductCategoryAdapter());
  _registerAdapterSafely(ProductVariantModelAdapter());
  _registerAdapterSafely(ProductSizeAdapter());
  _registerAdapterSafely(ProductModelAdapter());

  // Register Category Adapters
  _registerAdapterSafely(CategoryModelAdapter());

  // Register Order Adapters
  _registerAdapterSafely(OrderStatusAdapter());
  _registerAdapterSafely(PaymentStatusAdapter());
  _registerAdapterSafely(OrderModelAdapter());
  _registerAdapterSafely(OrderItemModelAdapter());

  await Future.wait([
    Hive.openBox<DashboardUser>('dashboardUsers'),
    Hive.openBox<ProductModel>('products'),
    Hive.openBox<CategoryModel>('categories'),
    Hive.openBox<OrderModel>('orders'),
    Hive.openBox<UserAddress>('addresses'),
    Hive.openBox<UserModel>('users'),
    Hive.openBox('brands'),
    Hive.openBox('dashboard_stats'),
    Hive.openBox('navigation_badges'),
    Hive.openBox('notifications_cache'),
    Hive.openBox('promos_cache'),
    Hive.openBox('settings_cache'),
    Hive.openBox('theme_cache'),
    Hive.openBox('support_cache'),
    Hive.openBox('users_stats_cache'),
  ]);
}
