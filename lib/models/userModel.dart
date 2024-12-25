class UserModel {
  String email;
  bool isAdmin;

  UserModel({required this.email, this.isAdmin = false});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
