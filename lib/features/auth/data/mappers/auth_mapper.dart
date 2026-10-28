import '../../domain/entities/auth_entity.dart';
import '../models/auth_model.dart';

/// Extension Mappers converting between [AuthModel] (DTO) and [AuthEntity] (Domain).
/// Ensures strict separation of concerns across the data and domain boundaries.
extension AuthModelX on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      token: token,
      profileImage: profileImage,
    );
  }
}

extension AuthEntityX on AuthEntity {
  AuthModel toModel() {
    return AuthModel(
      id: id,
      name: name,
      email: email,
      role: role,
      token: token,
      profileImage: profileImage,
    );
  }
}
