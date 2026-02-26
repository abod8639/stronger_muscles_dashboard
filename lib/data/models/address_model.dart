import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
@HiveType(typeId: 4, adapterName: 'AddressModelAdapter')
class AddressModel with _$AddressModel {
  const factory AddressModel({
    @HiveField(0) @JsonKey(fromJson: _parseInt) required int id,
    @HiveField(1)
    @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
    int? userId,
    @HiveField(2) String? label,
    @HiveField(3) @JsonKey(name: 'full_name') String? fullName,
    @HiveField(4) String? phone,
    @HiveField(5) required String street,
    @HiveField(6) required String city,
    @HiveField(7) String? state,
    @HiveField(8) @JsonKey(name: 'postal_code') String? postalCode,
    @HiveField(9) String? country,
    @HiveField(10)
    @JsonKey(name: 'is_default', fromJson: _parseBool)
    @Default(false)
    bool isDefault,
    @HiveField(11) @JsonKey(fromJson: _parseDoubleNullable) double? latitude,
    @HiveField(12) @JsonKey(fromJson: _parseDoubleNullable) double? longitude,
    @HiveField(13) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(14) @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _AddressModel;

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  String get fullAddress => [
    street,
    city,
    state,
    postalCode,
    country,
  ].where((e) => e != null && e.isNotEmpty).join(', ');
  String get shortAddress => '$city, $country';
  bool get hasCoordinates => latitude != null && longitude != null;
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final s = value.toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}
