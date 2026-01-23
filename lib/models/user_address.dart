
class UserAddress {
  final int id;
  final String city;
  final String street;
  final bool isDefault;

  UserAddress({
    required this.id,
    required this.city,
    required this.street,
    required this.isDefault,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }
}