import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'general_providers.dart';

// notifier tema
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // carichiamo il tema salvato all'inizializzazione
    final repo = ref.watch(preferencesRepositoryProvider);
    return repo.getThemeMode();
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    // Salviamo la preferenza
    ref.read(preferencesRepositoryProvider).saveThemeMode(newMode);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
