import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/data/models/dashboard_user_model.dart';
import 'package:stronger_muscles_dashboard/data/services/api_service.dart';

class UsersController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = true.obs;
  final totalUsers = 0.obs;

  final _allUsers = <DashboardUser>[].obs;

  final filteredUsers = <DashboardUser>[].obs;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersStats();
    ever(searchQuery, (_) => _applyFilter());
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  void _applyFilter() {
    if (searchQuery.trim().isEmpty) {
      filteredUsers.assignAll(_allUsers);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredUsers.assignAll(
        _allUsers.where((user) {
          final nameMatch = user.name.toLowerCase().contains(query);
          final emailMatch = user.email?.toLowerCase().contains(query) ?? false;
          final phoneMatch = user.phone?.contains(query) ?? false;
          return nameMatch || emailMatch || phoneMatch;
        }).toList(),
      );
    }
  }

  Future<void> fetchUsersStats() async {
    try {
      isLoading.value = true;

      final data = await _apiService.fetchUsersStats();
      final response = DashboardResponse.fromJson(data);

      totalUsers.value = response.totalUsers;

      _allUsers.assignAll(response.users);
      _applyFilter();
    } catch (e) {
      _showErrorSnackbar('فشل تحميل بيانات المستخدمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.errorContainer,
      colorText: Get.theme.colorScheme.onErrorContainer,
    );
  }

  void updateUserInfo(DashboardUser updatedUser) {
    final index = _allUsers.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _allUsers[index] = updatedUser;
      _applyFilter();
    }
  }
}
