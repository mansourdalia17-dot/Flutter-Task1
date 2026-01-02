import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../../core/auth_storage.dart';
import '../model/booking_model.dart';
import '../model/booking_request_model.dart';

class BookingRepository {
  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    final h = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  String _extractMessage(String body, {required String fallback}) {
    try {
      final raw = body.trim();
      if (raw.isEmpty) return fallback;

      // If backend returns plain text (not JSON), show it as-is
      if (!(raw.startsWith('{') || raw.startsWith('['))) return raw;

      final decoded = jsonDecode(raw);

      // -------- Map shape (ProblemDetails / custom) --------
      if (decoded is Map) {
        // Most common keys
        final msg = decoded['message'] ?? decoded['error'];
        if (msg != null && msg.toString().trim().isNotEmpty) {
          return msg.toString().trim();
        }

        // ASP.NET ProblemDetails keys
        final detail = decoded['detail'];
        if (detail != null && detail.toString().trim().isNotEmpty) {
          return detail.toString().trim();
        }

        final title = decoded['title'];
        if (title != null && title.toString().trim().isNotEmpty) {
          return title.toString().trim();
        }

        // ASP.NET ValidationProblemDetails: { errors: { Field: ["msg"] } }
        final errors = decoded['errors'];
        if (errors is Map) {
          final parts = <String>[];
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              parts.add(value.first.toString());
            } else if (value != null) {
              parts.add(value.toString());
            }
          });
          if (parts.isNotEmpty) return parts.join('\n');
        }

        // Sometimes: { "$values": [...] }
        final values = decoded[r'$values'];
        if (values is List && values.isNotEmpty) {
          return values.map((e) => e.toString()).join('\n');
        }

        return fallback;
      }

      // -------- List shape (Identity errors often come as list) --------
      if (decoded is List && decoded.isNotEmpty) {
        final first = decoded.first;

        if (first is Map) {
          final desc = first['description'] ?? first['message'] ?? first['error'];
          if (desc != null && desc.toString().trim().isNotEmpty) {
            return desc.toString().trim();
          }
        }

        return decoded.map((e) => e.toString()).join('\n');
      }

      return fallback;
    } catch (_) {
      // If parsing fails, show raw body if it exists, otherwise fallback
      final raw = body.trim();
      return raw.isNotEmpty ? raw : fallback;
    }
  }


  Future<void> createBooking(BookingRequest req) async {
    final res = await http.post(
      ApiConfig.uri(ApiConfig.bookings),
      headers: await _headers(),
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) return;
    throw Exception(_extractMessage(res.body, fallback: 'Booking failed (${res.statusCode})'));
  }

  Future<void> updateBooking(int bookingId, BookingRequest req) async {
    final res = await http.put(
      ApiConfig.uri('${ApiConfig.bookings}/$bookingId'),
      headers: await _headers(),
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception(_extractMessage(res.body, fallback: 'Update failed (${res.statusCode})'));
  }

  // ✅ FIXED: robust list extraction for Flutter Web / different API shapes
  Future<List<BookingModel>> fetchMyBookings() async {
    final res = await http.get(
      ApiConfig.uri(ApiConfig.myBookings),
      headers: await _headers(),
    );

    if (res.statusCode != 200) {
      throw Exception(_extractMessage(res.body, fallback: 'Load bookings failed (${res.statusCode})'));
    }

    final decoded = jsonDecode(res.body);

    List<dynamic> rawList = <dynamic>[];

    if (decoded is List) {
      rawList = decoded;
    } else if (decoded is Map) {
      // common shapes: { data: [] } or { items: [] }
      final data = decoded['data'];
      final items = decoded['items'];

      if (data is List) {
        rawList = data;
      } else if (items is List) {
        rawList = items;
      }
      // ASP.NET sometimes returns: { "$values": [...] }
      else if (decoded[r'$values'] is List) {
        rawList = decoded[r'$values'] as List;
      } else {
        rawList = <dynamic>[];
      }
    }

    // ✅ convert Map<dynamic,dynamic> safely to Map<String,dynamic>
    return rawList
        .whereType<Map>()
        .map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> deleteBooking(int bookingId) async {
    final res = await http.delete(
      ApiConfig.uri('${ApiConfig.bookings}/$bookingId'),
      headers: await _headers(),
    );

    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception(_extractMessage(res.body, fallback: 'Delete failed (${res.statusCode})'));
  }
}
