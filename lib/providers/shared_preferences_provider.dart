// provider per l'accesso alle SharedPreferences (utente + tema)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider per SharedPreferences inizializzato nel main con override
// obblighiamo override nel main 
// scrittura è async lettura è sincrona
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
