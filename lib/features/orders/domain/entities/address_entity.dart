class AddressEntity {
  final int id;
  final int? userId;
  final String? label;
  final String? fullName;
  final String? phone;
  final String street;
  final String city;
  final String? state;
  final String? postalCode;
  final String? country;
  final bool isDefault;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddressEntity({
    required this.id,
    this.userId,
    this.label,
    this.fullName,
    this.phone,
    required this.street,
    required this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault = false,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  String get fullAddress => [
    street,
    city,
    state,
    postalCode,
    country,
  ].where((e) => e != null && e.isNotEmpty).join(', ');

  String get shortAddress => '$city, ${country ?? ''}';
  bool get hasCoordinates => latitude != null && longitude != null;
}
