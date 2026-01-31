// provider per la gestione e la persistenza del profilo utente
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user.dart';
import 'shared_preferences_provider.dart';

// notifier user
class UserNotifier extends Notifier<User?> {
  static const _userKey = 'user_profile';

  @override
  User? build() {
    // carichiamo l'utente salvato in modo sincrono
    final prefs = ref.read(sharedPreferencesProvider); // basta la lettura perché l'istanza non cambia (i dati sì)
    final jsonStr = prefs.getString(_userKey);
    
    if (jsonStr == null) return null;
    try {
      return User.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_userKey, user.toJson());
    state = user;
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});

