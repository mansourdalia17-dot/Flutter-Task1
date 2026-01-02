class UserModel {
  final String? id;
  final String? email;
  final String? phoneNumber;

  const UserModel({this.id, this.email, this.phoneNumber});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['userId'] ?? json['Id'])?.toString(),
      email: (json['email'] ?? json['Email'])?.toString(),
      phoneNumber: (json['phoneNumber'] ?? json['PhoneNumber'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'phoneNumber': phoneNumber,
  };
}
