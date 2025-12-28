import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  static const _themeKey = 'theme_mode';
  static const _userKey = 'user_profile';

  // Gestione Tema
  Future<void> saveThemeMode(ThemeMode mode) async {
    // Salviamo come stringa o int
    await _prefs.setInt(_themeKey, mode.index);
  }

  ThemeMode getThemeMode() {
    final index = _prefs.getInt(_themeKey);
    if (index == null) return ThemeMode.light; // Default
    return ThemeMode.values[index];
  }

  // Gestione Utente
  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, user.toJson());
  }

  User? getUser() {
    final jsonStr = _prefs.getString(_userKey);
    if (jsonStr == null) return null;
    try {
      return User.fromJson(jsonStr);
    } catch (e) {
      return null;
    }
  }
}
