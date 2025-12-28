import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user.dart';
import '../data/repositories/preferences_repository.dart';

// 1. Provider per SharedPreferences (inizializzato nel main con override)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// 2. Provider per il Repository
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesRepository(prefs);
});

// 3. Notifier per il Tema (con persistenza)
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Carichiamo il tema salvato all'inizializzazione
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

// 4. Notifier per l'Utente (Profilo)
class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    // Carichiamo l'utente salvato
    return ref.watch(preferencesRepositoryProvider).getUser();
  }

  Future<void> saveUser(User user) async {
    state = user;
    await ref.read(preferencesRepositoryProvider).saveUser(user);
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});
