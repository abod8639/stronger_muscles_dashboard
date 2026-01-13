class UserModel {
  final int id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
    this.preferredLanguage = 'ar',
    this.notificationsEnabled = true,
    this.role = 'user',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      phoneNumber: json['phone_number'],
      preferredLanguage: json['preferred_language'] ?? 'ar',
      notificationsEnabled:
          json['notifications_enabled'] == 1 ||
          json['notifications_enabled'] == true,
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'preferred_language': preferredLanguage,
      'notifications_enabled': notificationsEnabled,
      'role': role,
    };
  }
}
