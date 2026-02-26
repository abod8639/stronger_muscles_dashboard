import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 16, adapterName: 'UserModelAdapter') // استخدام ID فريد
@JsonSerializable()
class UserModel with _$UserModel {
  const factory UserModel({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) String? photoUrl,
    @HiveField(4) String? phoneNumber,
    @HiveField(5) @Default('ar') String preferredLanguage,
    @HiveField(6) @Default(true) bool notificationsEnabled,
    @HiveField(7) @Default('user') String? role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
