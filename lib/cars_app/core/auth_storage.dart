import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_project/cars_app/cars_login/model/user_model.dart';

class AuthStorage {
  static const _kToken = 'carzy_token';
  static const _kUser = 'carzy_user';

  static Future<void> saveSession({
    required String token,
    UserModel? user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);

    if (user != null) {
      await prefs.setString(_kUser, jsonEncode(user.toJson()));
    } else {
      await prefs.remove(_kUser);
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_kToken);
    if (t == null || t.trim().isEmpty) return null;
    return t;
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;

    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) return UserModel.fromJson(map);
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
  }

  // ✅ Backward compatibility (some of your screens call these)
  static Future<void> clearSession() => clear();
  static Future<String?> readToken() => getToken();
}
