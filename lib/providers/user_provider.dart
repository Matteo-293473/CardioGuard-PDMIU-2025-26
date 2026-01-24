import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user.dart';
import 'general_providers.dart';

// notifier user
class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {

    // carichiamo l'utente salvato
    final repo = ref.watch(preferencesRepositoryProvider);
    return repo.getUser();
  }

  Future<void> saveUser(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(preferencesRepositoryProvider);
      await repo.saveUser(user);
      return user;
    });
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(() {
  return UserNotifier();
});
