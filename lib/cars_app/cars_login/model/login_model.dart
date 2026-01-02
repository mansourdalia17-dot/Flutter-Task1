import 'user_model.dart';

class LoginModel {
  final String? token;
  final UserModel? user;
  final String? message;

  const LoginModel({this.token, this.user, this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final token = (json['token'] ??
        json['accessToken'] ??
        json['jwt'] ??
        json['Token'])
        ?.toString();

    final userJson = json['user'] ?? json['User'];
    return LoginModel(
      token: token,
      user: userJson is Map<String, dynamic> ? UserModel.fromJson(userJson) : null,
      message: (json['message'] ?? json['Message'])?.toString(),
    );
  }
}
