class AuthResponse {
  final String? token;
  final Map<String, dynamic>? user;

  const AuthResponse({this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // token can be: token / accessToken / jwt / data.token ...
    final token = (json['token'] ??
        json['accessToken'] ??
        json['jwt'] ??
        (json['data'] is Map ? (json['data']['token'] ?? json['data']['accessToken']) : null))
        ?.toString();

    final user = (json['user'] is Map)
        ? Map<String, dynamic>.from(json['user'])
        : (json['data'] is Map && json['data']['user'] is Map)
        ? Map<String, dynamic>.from(json['data']['user'])
        : null;

    return AuthResponse(token: token, user: user);
  }
}
