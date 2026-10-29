import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository _repository;

  const GetUsersUseCase(this._repository);

  Future<Either<Failure, List<UserEntity>>> call({
    bool forceRefresh = false,
  }) async {
    return _repository.getUsers(forceRefresh: forceRefresh);
  }
}
