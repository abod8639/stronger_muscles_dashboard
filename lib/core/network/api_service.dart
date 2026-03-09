import 'package:get/get.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/orders/data/datasources/order_remote_datasource.dart';
import 'api_base.dart';

/// Legacy Bridge: This class exists ONLY to support legacy controllers 
/// while we migrate to Clean Architecture. Use specific DataSources/Repositories instead.
class ApiService {
  final ApiBase _apiBase = Get.find<ApiBase>();
  
  // Delegating tasks to new DataSources
  late final _productDS = ProductRemoteDataSourceImpl(_apiBase.dio);
  late final _categoryDS = CategoryRemoteDataSourceImpl(_apiBase.dio);
  late final _orderDS = OrderRemoteDataSourceImpl(_apiBase.dio);

  Future<bool> checkConnection() async {
    try {
      final response = await _apiBase.dio.get('/categories', queryParameters: {'tree': 1});
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Legacy Proxy Methods
  Future<List<dynamic>> fetchProducts() async => await _productDS.getProducts();
  Future<List<dynamic>> fetchCategories({bool tree = false}) async => await _categoryDS.getCategories(tree: tree);
  Future<List<dynamic>> fetchOrders() async => await _orderDS.getOrders();
  
  // Media (Temp helpers)
  Future<String> uploadProductImage(String filePath) async {
    // Logic for upload can be moved to a specific MediaDataSource later
    return "uploaded_url_placeholder"; 
  }

  Future<Map<String, dynamic>> fetchUsersStats() async {
    final response = await _apiBase.dio.get('/users/stats');
    return response.data;
  }
}
