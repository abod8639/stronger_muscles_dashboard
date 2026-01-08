
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/services/api_service.dart';

class UsersController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final isLoading = true.obs;
  final totalUsers = 0.obs;
  final users = <DashboardUser>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersStats();
  }

  Future<void> fetchUsersStats() async {
    try {
      isLoading.value = true;
      final data = await _apiService.fetchUsersStats();
      final response = DashboardResponse.fromJson(data);
      
      totalUsers.value = response.totalUsers;
      users.assignAll(response.users);
      
    } catch (e) {
      print('Error fetching users stats: $e');
      Get.snackbar('خطأ', 'فشل تحميل بيانات المستخدمين');
    } finally {
      isLoading.value = false;
    }
  }
}
