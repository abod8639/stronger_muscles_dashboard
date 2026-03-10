import '../repositories/user_repository.dart';

class GetUsersStatsUseCase {
  final UserRepository repository;

  GetUsersStatsUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getUsersStats();
  }
}
