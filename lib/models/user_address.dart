import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_address.freezed.dart';
part 'user_address.g.dart';

@freezed
@HiveType(typeId: 15, adapterName: 'UserAddressAdapter')
class UserAddress with _$UserAddress {
  const UserAddress._();

  const factory UserAddress({
    @HiveField(0) required String id,
    @HiveField(1) @Default('') String label,
    @HiveField(2) @JsonKey(name: 'full_name') @Default('') String fullName,
    @HiveField(3) @Default('') String phone,
    @HiveField(4) @Default('') String street,
    @HiveField(5) @Default('') String city,
    @HiveField(6) @Default('') String state,
    @HiveField(7) @JsonKey(name: 'postal_code') @Default('') String postalCode,
    @HiveField(8) @Default('') String country,
    @HiveField(9) @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @HiveField(10) double? latitude,
    @HiveField(11) double? longitude,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) => 
      _$UserAddressFromJson(_mapAddressJson(json));

  String get fullAddress {
    final parts = [street, city, state, country].where((s) => s.isNotEmpty);
    return parts.isEmpty ? 'العنوان غير محدد' : parts.join(', ');
  }
}

Map<String, dynamic> _mapAddressJson(Map<String, dynamic> json) {
  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'label': json['label']?.toString() ?? '',
    'full_name': json['full_name'] ?? json['fullName'] ?? '',
    'phone': json['phone']?.toString() ?? '',
    'street': json['street']?.toString() ?? '',
    'city': json['city']?.toString() ?? '',
    'state': json['state']?.toString() ?? '',
    'postal_code': json['postal_code'] ?? json['postalCode'] ?? '',
    'country': json['country']?.toString() ?? '',
    'is_default': json['is_default'] == true || json['is_default'] == 1 || json['isDefault'] == true,
    'latitude': double.tryParse(json['latitude']?.toString() ?? ''),
    'longitude': double.tryParse(json['longitude']?.toString() ?? ''),
  };
}