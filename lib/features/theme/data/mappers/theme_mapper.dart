import '../../domain/entities/app_theme_mode.dart';
import '../../domain/entities/theme_entity.dart';
import '../models/theme_model.dart';

/// Extension mapper converting [ThemeModel] DTO to domain [ThemeEntity].
extension ThemeModelMapper on ThemeModel {
  ThemeEntity toEntity() {
    return ThemeEntity(
      mode: AppThemeMode.fromString(mode),
      updatedAt: updatedAt,
    );
  }
}

/// Extension mapper converting domain [ThemeEntity] to data [ThemeModel] DTO.
extension ThemeEntityMapper on ThemeEntity {
  ThemeModel toModel() {
    return ThemeModel(
      mode: mode.storageKey,
      updatedAt: updatedAt,
    );
  }
}
