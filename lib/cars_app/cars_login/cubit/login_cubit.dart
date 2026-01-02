import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../model/login_model.dart';
import '../state/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  Map<String, dynamic>? _tryDecode(String body) {
    if (body.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  String _extractMessage(String body, {required String fallback}) {
    final map = _tryDecode(body);
    if (map == null) return fallback;
    return (map['message'] ?? map['error'] ?? fallback).toString();
  }

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());
    try {
      final res = await http.post(
        ApiConfig.uri(ApiConfig.loginEndpoint),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode != 200) {
        throw Exception(_extractMessage(res.body, fallback: 'Login failed (${res.statusCode})'));
      }

      final map = _tryDecode(res.body) ?? <String, dynamic>{};
      final login = LoginModel.fromJson(map);

      if (login.token == null || login.token!.isEmpty) {
        throw Exception(_extractMessage(res.body, fallback: 'Token missing from response'));
      }

      emit(LoginSuccess(login));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
