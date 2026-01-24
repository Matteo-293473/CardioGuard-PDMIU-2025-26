import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/preferences_repository.dart';

// 1. Provider per SharedPreferences options (inizializzato nel main con override)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// 2. Provider per il Repository
final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesRepository(prefs);
});
