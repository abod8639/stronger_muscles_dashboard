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
}
