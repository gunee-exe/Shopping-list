import 'package:flutter/material.dart';

class AppTheme {
  // Brand palette — deep forest green accent on dark slate
  static const Color _bg = Color(0xFF0F1117);
  static const Color _surface = Color(0xFF1A1D27);
  static const Color _card = Color(0xFF222533);
  static const Color _accent = Color(0xFF4ADE80);      // vivid green
  static const Color _accentDim = Color(0xFF166534);   // dark green tint
  static const Color _textPrimary = Color(0xFFF1F5F9);
  static const Color _textSecondary = Color(0xFF94A3B8);
  static const Color _danger = Color(0xFFFF6B6B);
  static const Color _border = Color(0xFF2D3148);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _bg,
      colorScheme: const ColorScheme.dark(
        primary: _accent,
        primaryContainer: _accentDim,
        surface: _surface,
        onSurface: _textPrimary,
        error: _danger,
      ),
      fontFamily: 'SF Pro Display',   // falls back to system sans-serif
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, letterSpacing: -1.5),
        headlineMedium: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: _textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: _textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: _textSecondary, fontSize: 14),
        labelLarge: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: _textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _textPrimary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _accent,
        foregroundColor: Color(0xFF052E16),
        elevation: 0,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        labelStyle: const TextStyle(color: _textSecondary),
        hintStyle: const TextStyle(color: _textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: const Color(0xFF052E16),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _accent),
      ),
      dividerTheme: const DividerThemeData(color: _border, space: 1, thickness: 1),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _card,
        contentTextStyle: TextStyle(color: _textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Expose colors for manual use
  static const Color accent = _accent;
  static const Color accentDim = _accentDim;
  static const Color textPrimary = _textPrimary;
  static const Color textSecondary = _textSecondary;
  static const Color danger = _danger;
  static const Color card = _card;
  static const Color surface = _surface;
  static const Color bg = _bg;
  static const Color border = _border;
}