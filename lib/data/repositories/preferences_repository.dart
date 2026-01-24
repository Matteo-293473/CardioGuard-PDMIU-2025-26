import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepository(this._prefs);

  static const _themeKey = 'theme_mode';
  static const _userKey = 'user_profile';
  static const _notificationsKey = 'notifications_enabled';

  // notifiche on/off
  Future<void> saveNotificationEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  bool getNotificationEnabled() {
    final value = _prefs.get(_notificationsKey);
    if (value is bool) return value;
    return false;
  }

  // tema
  Future<void> saveThemeMode(ThemeMode mode) async {
    // Salviamo come stringa o int
    await _prefs.setInt(_themeKey, mode.index);
  }

  ThemeMode getThemeMode() {
    final value = _prefs.get(_themeKey);
    if (value is int && value >= 0 && value < ThemeMode.values.length) {
      return ThemeMode.values[value];
    }
    return ThemeMode.light; // Default
  }

  // utente
  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, user.toJson());
  }

  User? getUser() {
    final jsonStr = _prefs.getString(_userKey);
    if (jsonStr == null) return null;
    try {
      return User.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }
}
