import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../model/login_model.dart';
import '../model/signup_model.dart';
import '../state/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupInitial());

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

  Future<void> signup(SignupModel model) async {
    emit(const SignupLoading());
    try {
      final res = await http.post(
        ApiConfig.uri(ApiConfig.registerEndpoint),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception(_extractMessage(res.body, fallback: 'Register failed (${res.statusCode})'));
      }

      // sometimes register returns token+user, sometimes just message
      final map = _tryDecode(res.body);
      final login = map == null ? null : LoginModel.fromJson(map);

      emit(SignupSuccess(
        message: _extractMessage(res.body, fallback: 'Registered successfully'),
        login: login?.token?.isNotEmpty == true ? login : null,
      ));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
