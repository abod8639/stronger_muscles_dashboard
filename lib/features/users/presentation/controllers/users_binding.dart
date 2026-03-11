import 'package:get/get.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_stats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import 'users_controller.dart';
import '../../../../core/network/api_base.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    // Service
    Get.lazyPut(() => UserService());

    // Data Sources
    Get.lazyPut<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(Get.find<UserService>()));

    // Repository
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(Get.find<UserRemoteDataSource>()));

    // Use Cases
    Get.lazyPut(() => GetUsersStatsUseCase(Get.find<UserRepository>()));
    Get.lazyPut(() => GetUsersUseCase(Get.find<UserRepository>()));

    // Controller
    Get.put(UsersController(
      getUsersStatsUseCase: Get.find<GetUsersStatsUseCase>(),
      getUsersUseCase: Get.find<GetUsersUseCase>(),
    ));
  }
}
