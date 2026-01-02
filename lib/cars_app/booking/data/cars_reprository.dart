import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:studio_project/cars_app/core/api_config.dart';
import 'package:studio_project/cars_app/core/auth_storage.dart';
import 'package:studio_project/cars_app/cars/model/car_model.dart';

class CarRepository {
  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    final h = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<List<CarModel>> fetchCars() async {
    return _getCars(ApiConfig.carsAvailable);
  }

  /// If your backend returns already sorted, great.
  /// If not, we sort client-side in the cubit anyway.
  Future<List<CarModel>> fetchCarsByPrice() async {
    return _getCars(ApiConfig.carsByPrice);
  }

  Future<List<CarModel>> fetchCarsByYear() async {
    return _getCars(ApiConfig.carsByYear);
  }

  Future<List<CarModel>> fetchCarsByCity() async {
    return _getCars(ApiConfig.carsByCity);
  }

  Future<List<CarModel>> _getCars(String endpoint) async {
    final res = await http.get(
      Uri.parse(ApiConfig.url(endpoint)),
      headers: await _headers(),
    );

    if (res.statusCode != 200) {
      final body = res.body.trim();
      final msg = body.isEmpty ? 'Cars API failed (${res.statusCode})' : body;
      throw Exception(msg);
    }

    final decoded = jsonDecode(res.body);

    final list = decoded is List
        ? decoded
        : (decoded is Map && decoded['data'] is List ? decoded['data'] as List : const []);

    return list
        .whereType<Map>()
        .map((e) => CarModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
