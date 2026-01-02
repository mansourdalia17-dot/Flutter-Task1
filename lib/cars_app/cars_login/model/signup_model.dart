class SignupModel {
  final String email;
  final String password;
  final String phoneNumber;

  const SignupModel({
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "phoneNumber": phoneNumber,
  };
}
