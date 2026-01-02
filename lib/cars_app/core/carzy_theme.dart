import 'package:flutter/material.dart';

class CarZyTheme {
  CarZyTheme._();

  static const navy = Color(0xFF1F2E4E); // from template
  static const red = Color(0xFFEC001D); // from template
  static const bg = Color(0xFFF6F7FB);
  static const fieldBg = Color(0xFFF1F5F9);
  static const textDark = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const gold = Color(0xFFF5C542); // warm gold
  static const goldSoft = Color(0xFFFFF3C4);


  static InputDecoration fieldDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, color: muted),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: red, width: 1.5),
      ),
    );
  }
}
