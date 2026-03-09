import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_controller.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final apiBase = Get.find<ApiBase>();
    final dio = apiBase.dio;
    final storage = GetStorage();

    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio));
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(storage));

    // Repository
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
          remoteDataSource: Get.find<AuthRemoteDataSource>(),
          localDataSource: Get.find<AuthLocalDataSource>(),
        ));

    // Use Case
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()));

    // Controller
    Get.put(AuthController(loginUseCase: Get.find<LoginUseCase>()));
  }
}
