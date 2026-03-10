import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';

class UsersController extends GetxController {
  final GetUsersStatsUseCase getUsersStatsUseCase;
  final GetUsersUseCase getUsersUseCase;

  UsersController({
    required this.getUsersStatsUseCase,
    required this.getUsersUseCase,
  });

  final isLoading = true.obs;
  final totalUsers = 0.obs;

  final _allUsers = <UserEntity>[].obs;
  final filteredUsers = <UserEntity>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersData();
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

  Future<void> fetchUsersData() async {
    try {
      isLoading.value = true;

      // Fetch stats and users list in parallel
      final results = await Future.wait([
        getUsersStatsUseCase(),
        getUsersUseCase(),
      ]);

      final stats = results[0] as Map<String, dynamic>;
      final userList = results[1] as List<UserEntity>;

      if (stats.containsKey('total_users')) {
        totalUsers.value = int.tryParse(stats['total_users'].toString()) ?? 0;
      } else if (stats['data'] != null && stats['data']['total_users'] != null) {
        totalUsers.value = int.tryParse(stats['data']['total_users'].toString()) ?? 0;
      }

      _allUsers.assignAll(userList);
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
