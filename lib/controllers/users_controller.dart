import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';

class UsersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final isLoading = false.obs;
  final usersStats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersStats();
  }

  Future<void> fetchUsersStats() async {
    try {
      isLoading.value = true;
      final data = await _apiService.fetchUsersStats();
      usersStats.value = data;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب إحصائيات المستخدمين');
    } finally {
      isLoading.value = false;
    }
  }
}
