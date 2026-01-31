// provider per la gestione e la persistenza del tema dell'applicazione
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

// notifier tema
class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    // carichiamo il tema salvato all'inizializzazione
    final prefs = ref.read(sharedPreferencesProvider);
    final value = prefs.get(_themeKey);
    if (value is int && value >= 0 && value < ThemeMode.values.length) {
      return ThemeMode.values[value];
    }
    return ThemeMode.light; // Default
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    // salviamo la preferenza
    await ref.read(sharedPreferencesProvider).setInt(_themeKey, newMode.index);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
