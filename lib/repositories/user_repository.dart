import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<Map<String, dynamic>> getUsersStats() async {
    try {
      return await _apiService.fetchUsersStats();
    } catch (e) {
      print('خطأ في UserRepository: $e');
      rethrow;
    }
  }
}
