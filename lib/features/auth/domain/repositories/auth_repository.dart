import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password);
  Future<AuthEntity> signup(String name, String email, String password);
  Future<void> logout();
  bool isLoggedIn();
  String? getToken();
}
