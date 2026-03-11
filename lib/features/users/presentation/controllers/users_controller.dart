import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';

class UsersController extends GetxController {
  final GetUsersStatsUseCase _getUsersStatsUseCase;

  UsersController({
    required GetUsersStatsUseCase getUsersStatsUseCase,
  })  : _getUsersStatsUseCase = getUsersStatsUseCase;

  final isLoading = true.obs;
  final totalUsers = 0.obs;
  final activeUsers = 0.obs;
  final inactiveUsers = 0.obs;

  final _allUsers = <UserEntity>[].obs;
  final filteredUsers = <UserEntity>[].obs;
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
          final phoneMatch = user.phoneNumber?.contains(query) ?? false;
          return nameMatch || emailMatch || phoneMatch;
        }).toList(),
      );
    }
  }

  Future<void> fetchUsersStats() async {
    try {
      isLoading.value = true;
      final stats = await _getUsersStatsUseCase();

      totalUsers.value = stats.totalUsers;
      activeUsers.value = stats.activeUsers;
      inactiveUsers.value = stats.inactiveUsers;

      _allUsers.assignAll(stats.users);
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

  void updateUserInfo(UserEntity updatedUser) {
    final index = _allUsers.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _allUsers[index] = updatedUser;
      _applyFilter();
    }
  }
}
