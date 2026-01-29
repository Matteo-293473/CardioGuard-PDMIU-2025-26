import 'package:flutter/material.dart';
import '../app_constants.dart';

class AppTheme {
  // un colore seed per il tema
  static const Color _seedColor = Color(0xFF006064);

  // tema chiaro
  static ThemeData get lightTheme => buildTheme(Brightness.light);

  // tema scuro
  static ThemeData get darkTheme => buildTheme(Brightness.dark);

  // helper pubblico per costruire il tema con scaling opzionale
  static ThemeData buildTheme(Brightness brightness, {bool isLarge = false}) {
    final scale = isLarge ? 1.4 : 1.0;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: isLarge ? 80.0 : 56.0,
        iconTheme: IconThemeData(
          size: isLarge ? 32 : 24,
          color: brightness == Brightness.dark ? Colors.white : null,
        ),
        foregroundColor: brightness == Brightness.dark ? Colors.white : null,
      ),
      cardTheme: CardThemeData(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultRadius)),
      ),
      iconTheme: IconThemeData(size: 24.0 * scale),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(48 * scale),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultRadius)),
          padding: EdgeInsets.symmetric(horizontal: 24 * scale, vertical: 12 * scale),
          textStyle: TextStyle(fontSize: 14 * scale),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // adattiamo il colore di sfondo in base al tema
        fillColor: brightness == Brightness.light
            ? Colors.grey.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: _seedColor, width: 1),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
      ),
    );
  }
}
