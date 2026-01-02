import 'dart:convert';
import 'package:http/http.dart' as http;
import 'message_request.dart';

class MessagesApi {
  final String baseUrl; // e.g. http://10.0.2.2:5159
  final http.Client _client;

  MessagesApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<void> sendMessage(MessageRequest dto, {String? bearerToken}) async {
    final url = Uri.parse("$baseUrl/api/messages");

    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers["Authorization"] = "Bearer $bearerToken";
    }

    final res = await _client.post(
      url,
      headers: headers,
      body: jsonEncode(dto.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) return;

    // Try to parse ASP.NET validation errors
    String errorMsg = "Request failed: ${res.statusCode}";
    try {
      final body = jsonDecode(res.body);

      // Typical ASP.NET ValidationProblemDetails:
      // { "title": "...", "status": 400, "errors": { "Email": ["..."] } }
      if (body is Map && body["errors"] is Map) {
        final errors = body["errors"] as Map;
        final parts = <String>[];
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            parts.add("$key: ${value.first}");
          }
        });
        if (parts.isNotEmpty) {
          errorMsg = parts.join("\n");
        }
      } else if (body is Map && body["message"] is String) {
        errorMsg = body["message"];
      } else {
        errorMsg = res.body.toString();
      }
    } catch (_) {
      errorMsg = res.body.isNotEmpty ? res.body : errorMsg;
    }

    throw Exception(errorMsg);
  }
}
