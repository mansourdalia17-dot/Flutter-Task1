import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message; // ✅ so UI shows only message (no "Exception:")
}

String extractApiError(http.Response res, {String? fallback}) {
  final fb = fallback ?? 'Request failed (${res.statusCode})';
  final body = res.body.trim();
  if (body.isEmpty) return fb;

  // If backend returns plain text:
  if (!(body.startsWith('{') || body.startsWith('['))) return body;

  try {
    final decoded = jsonDecode(body);

    // --------- Case A: Map (ProblemDetails / ValidationProblemDetails) ---------
    if (decoded is Map) {
      // Common keys used in APIs
      final message = decoded['message'] ?? decoded['error'];
      if (message is String && message.trim().isNotEmpty) return message.trim();

      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail.trim();

      final title = decoded['title'];
      if (title is String && title.trim().isNotEmpty) return title.trim();

      // ASP.NET ValidationProblemDetails: { errors: { Field: ["msg"] } }
      final errors = decoded['errors'];
      if (errors is Map) {
        final parts = <String>[];
        errors.forEach((k, v) {
          if (v is List && v.isNotEmpty) {
            parts.add(v.first.toString());
          } else if (v != null) {
            parts.add(v.toString());
          }
        });
        if (parts.isNotEmpty) return parts.join('\n');
      }

      // Sometimes ASP.NET returns: { "$values": [...] }
      final values = decoded[r'$values'];
      if (values is List && values.isNotEmpty) {
        return values.map((e) => e.toString()).join('\n');
      }

      return fb;
    }

    // --------- Case B: List (Identity errors like [{code, description}]) ---------
    if (decoded is List && decoded.isNotEmpty) {
      final first = decoded.first;

      if (first is Map) {
        final desc = first['description'] ?? first['message'] ?? first['error'];
        if (desc != null) return desc.toString();
      }

      return decoded.map((e) => e.toString()).join('\n');
    }

    return fb;
  } catch (_) {
    // JSON parsing failed
    return body.isNotEmpty ? body : fb;
  }
}
