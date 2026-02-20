# حل مشكلة الطلبات المتكررة للخادم

## المشكلة
التطبيق كان يقوم بطلب نفس البيانات من قاعدة البيانات عدة مرات عند فتحه أو تحديث الصفحة:
- `/api/v1/shop/categories` - طُلب 3 مرات
- `/api/v1/admin/products` - طُلب عدة مرات
- `/api/v1/admin/orders` - طُلب مرتين
- `/api/v1/admin/users` - طُلب مرتين

## السبب الرئيسي
1. كل **Screen** كانت تقوم بـ `Get.put()` لإنشاء **Controller** جديد في كل مرة
2. كل **Controller** جديدة تقوم بإنشاء instances جديدة من **Repositories**
3. كل **Repository** تقوم بالطلب من الخادم بدون أي caching
4. عند التنقل بين الـ Screens أو إعادة البناء، يتم تكرار العملية كاملة

## الحل الذي تم تطبيقه

### 1. ✅ إنشاء `CacheService` (خدمة الـ Cache)
**الملف:** `lib/services/cache_service.dart`

- خدمة مركزية لإدارة الـ Cache مع **TTL (Time To Live)**
- الـ Cache الافتراضي: **5 دقائق** لكل البيانات
- يمكن تخصيص مدة الـ Cache لكل عملية
- تنظيف تلقائي للبيانات المنتهية الصلاحية

```dart
final cacheService = Get.find<CacheService>();

// الحصول على البيانات من الـ Cache
final products = cacheService.get<List<ProductModel>>('products_list');

// حفظ البيانات في الـ Cache
cacheService.set('products_list', products, cacheDurationSeconds: 300);

// حذف البيانات من الـ Cache
cacheService.remove('products_list');
```

### 2. ✅ تحديث `Repositories` لاستخدام Caching

#### ProductRepository
```dart
Future<List<ProductModel>> getProducts() async {
  // التحقق من الـ Cache أولاً
  final cachedData = _cacheService.get<List<ProductModel>>(_cacheKeyProducts);
  if (cachedData != null) {
    debugPrint('✓ تم استرجاع المنتجات من الـ Cache');
    return cachedData;
  }

  // الطلب من الخادم فقط إذا لم تكن البيانات موجودة في الـ Cache
  final products = await _apiService.fetchProducts();
  
  // حفظ البيانات في الـ Cache
  _cacheService.set(_cacheKeyProducts, products);
  return products;
}
```

#### معادلة Cache عند التعديل
```dart
Future<ProductModel> addProduct(Map<String, dynamic> productJson) async {
  // إضافة المنتج
  final result = await _apiService.addProduct(productJson);
  
  // تنظيف الـ Cache بعد الإضافة
  _cacheService.remove(_cacheKeyProducts);
  return result;
}
```

**تم تحديث:**
- `ProductRepository`
- `OrderRepository`
- `CategoryRepository`

### 3. ✅ تسجيل Controllers كـ Singletons

**الملف:** `lib/main.dart`

```dart
void _initializeServices() {
  // تسجيل CacheService كـ GetxService
  Get.put(CacheService(), permanent: true);
  
  // تسجيل Controllers كـ LazyPut (Singleton)
  Get.lazyPut(() => DashboardController(), fenix: true);
  Get.lazyPut(() => ProductsController(), fenix: true);
  Get.lazyPut(() => OrdersController(), fenix: true);
  Get.lazyPut(() => CategoriesController(), fenix: true);
  Get.lazyPut(() => UsersController(), fenix: true);
}
```

**الفوائد:**
- كل Controller يتم إنشاؤها **مرة واحدة فقط** في حياة التطبيق
- يتم استخدام `fenix: true` لإعادة إنشاء الـ Controller الوحيد الخاص به عند الحاجة
- لا تُنشأ instances جديدة عند التنقل بين الـ Screens

### 4. ✅ استخدام `Get.find()` بدلاً من `Get.put()` في الـ Screens

**قبل:**
```dart
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController()); // ❌ إنشاء جديد في كل مرة
  }
}
```

**بعد:**
```dart
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>(); // ✅ استخدام الـ Singleton
  }
}
```

**تم التحديث لـ:**
- `DashboardScreen`
- `ProductsScreen`
- `OrdersScreen`
- `CategoriesScreen`
- `UsersScreen`

### 5. ✅ إضافة Debouncing في DashboardController

```dart
// --- Debounce Mechanism ---
DateTime? _lastFetchTime;
static const Duration _minFetchInterval = Duration(seconds: 2);

Future<void> fetchDashboardData() async {
  // تجنب الطلبات المتكررة بفترة زمنية قصيرة
  final now = DateTime.now();
  if (_lastFetchTime != null &&
      now.difference(_lastFetchTime!) < _minFetchInterval) {
    return; // تجاهل الطلب المكرر
  }
  _lastFetchTime = now;
  
  // ... بقية الكود
}
```

## النتائج المتوقعة

### قبل الحل:
```
2026-02-19 01:04:15 /api/v1/shop/categories ........... ~ 0.23ms
2026-02-19 01:04:15 /api/v1/shop/categories ........... ~ 2.31ms
2026-02-19 01:04:15 /api/v1/shop/categories ........... ~ 4.83ms
2026-02-19 01:04:15 /api/v1/admin/products ........... ~ 7.60ms
2026-02-19 01:04:15 /api/v1/admin/products ........... ~ 0.15ms
... (طلبات متكررة كثيرة)
```

### بعد الحل:
- ✅ **تقليل الطلبات بنسبة كبيرة (حوالي 70-80%)**
- ✅ **البيانات تُخزّن في الـ Cache لمدة 5 دقائق**
- ✅ **عند فتح Screen نفسها مرة أخرى، تُسترجع البيانات من الـ Cache مباشرة**
- ✅ **عند تحديث البيانات (Add/Edit/Delete)، يتم تنظيف الـ Cache تلقائياً**

## مثال عملي

### السيناريو: فتح التطبيق ثم الانتقال للمنتجات ثم العودة للصفحة الرئيسية

**قبل الحل:**
```
1️⃣ فتح التطبيق
   → Dashboard: getProducts(), getOrders(), getCategories()
   
2️⃣ الذهاب لـ Products Screen
   → Products: getProducts() مرة أخرى ❌
   
3️⃣ العودة للـ Dashboard
   → Dashboard: getProducts(), getOrders(), getCategories() مرة أخرى ❌
```

**بعد الحل:**
```
1️⃣ فتح التطبيق
   → Dashboard: (HTTP) getProducts(), getOrders(), getCategories()
   
2️⃣ الذهاب لـ Products Screen
   → Products: (CACHE) getProducts() - بدون طلب من الخادم ✅
   
3️⃣ العودة للـ Dashboard
   → Dashboard: (CACHE) getProducts(), getOrders(), getCategories() ✅
```

## تخصيصات إضافية يمكن عملها

### تغيير مدة التخزين المؤقت:
```dart
// تخزين لمدة 10 دقائق بدلاً من 5
_cacheService.set(
  _cacheKeyProducts,
  products,
  cacheDurationSeconds: 600, // 10 دقائق
);
```

### تنظيف الـ Cache يدويّاً:
```dart
// تنظيف Cache معين
_cacheService.remove('products_list');

// تنظيف جميع الـ Cache
_cacheService.clear();
```

### التحقق من حالة الـ Cache (للـ Debugging):
```dart
// الحصول على إحصائيات الـ Cache
final stats = Get.find<CacheService>().getStats();
print(stats); // سيطبع:
// {
//   totalEntries: 3,
//   entries: [
//     {key: 'products_list', isExpired: false, expiresIn: Duration(minutes: 4, seconds: 30)},
//     ...
//   ]
// }
```

## الملفات التي تم تعديلها

1. ✅ `lib/services/cache_service.dart` - **ملف جديد**
2. ✅ `lib/main.dart` - إضافة `_initializeServices()`
3. ✅ `lib/repositories/product_repository.dart` - إضافة caching
4. ✅ `lib/repositories/order_repository.dart` - إضافة caching
5. ✅ `lib/repositories/category_repository.dart` - إضافة caching
6. ✅ `lib/controllers/dashboard_controller.dart` - إضافة debouncing
7. ✅ `lib/screens/dashboard_screen/dashboard_screen.dart` - استخدام `Get.find()`
8. ✅ `lib/screens/products_screen/products_screen.dart` - استخدام `Get.find()`
9. ✅ `lib/screens/orders_screen/orders_screen.dart` - استخدام `Get.find()`
10. ✅ `lib/screens/categories_screen/categories_screen.dart` - استخدام `Get.find()`
11. ✅ `lib/screens/users_screen/users_screen.dart` - استخدام `Get.find()`
12. ✅ `lib/controllers/index.dart` - إضافة orders_controller و navigation_controller

## الخطوات التالية المقترحة

1. **قياس الأداء**: قارن عدد الطلبات قبل وبعد الحل
2. **تعديل مدة الـ Cache**: يمكنك تقليلها أو زيادتها حسب احتياجات تطبيقك
3. **إضافة Refresh Manual**: السماح للمستخدم بتحديث البيانات يدويّاً
4. **Monitoring**: إضافة logging للـ Cache لمراقبة الأداء
