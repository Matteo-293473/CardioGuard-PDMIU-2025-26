import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class HomeGreeting extends ConsumerWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) {
        final name = user?.name ?? "";
        return Text(
          name.isEmpty ? 'Benvenuto in CardioGuard!' : 'Benvenuto, $name!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        );
      },
      loading: () => const Text('Caricamento...'),
      error: (_, __) => const Text('Benvenuto in CardioGuard!'),
    );
  }
}
