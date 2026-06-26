enum UserRole { parent, student }

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      role: json['role'] == 'parent' ? UserRole.parent : UserRole.student,
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role == UserRole.parent ? 'parent' : 'student',
      'avatar_url': avatarUrl,
    };
  }
}
