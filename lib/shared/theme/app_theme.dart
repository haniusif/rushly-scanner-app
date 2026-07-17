import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light(Locale locale) => _base(
        Brightness.light,
        Colors.white,
        const Color(0xFFE64A19),
        locale,
      );
  static ThemeData dark(Locale locale) => _base(
        Brightness.dark,
        const Color(0xFF121212),
        const Color(0xFFE64A19),
        locale,
      );

  static ThemeData _base(
    Brightness brightness,
    Color bg,
    Color seed,
    Locale locale,
  ) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final base = ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: scheme,
      useMaterial3: true,
    );
    final text = locale.languageCode == 'ar'
        ? GoogleFonts.tajawalTextTheme(base.textTheme)
        : GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(textTheme: text);
  }
}
