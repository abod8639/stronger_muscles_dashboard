import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_address.freezed.dart';
part 'user_address.g.dart';

@freezed
@HiveType(typeId: 15, adapterName: 'UserAddressAdapter')
@JsonSerializable()
class UserAddress with _$UserAddress {
  const factory UserAddress({
    @HiveField(0) required int id,
    @HiveField(1) @Default('') String city,
    @HiveField(2) @Default('') String street,
    @HiveField(3) @Default(false) bool isDefault,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) => 
      _$UserAddressFromJson(json);
}