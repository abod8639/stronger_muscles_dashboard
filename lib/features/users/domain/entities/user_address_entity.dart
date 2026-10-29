class UserAddressEntity {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const UserAddressEntity({
    required this.id,
    this.label = '',
    this.fullName = '',
    this.phone = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  String get fullAddress {
    final parts = [street, city, state, country].where((s) => s.isNotEmpty);
    return parts.isEmpty ? 'العنوان غير محدد' : parts.join(', ');
  }

  UserAddressEntity copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return UserAddressEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddressEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          fullName == other.fullName &&
          phone == other.phone &&
          street == other.street &&
          city == other.city &&
          isDefault == other.isDefault;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      fullName.hashCode ^
      phone.hashCode ^
      street.hashCode ^
      city.hashCode ^
      isDefault.hashCode;

  @override
  String toString() =>
      'UserAddressEntity(id: $id, label: $label, fullAddress: $fullAddress)';
}
