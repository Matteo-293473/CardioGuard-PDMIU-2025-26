// widget messaggio di benvenuto basato su dati utente
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class HomeGreeting extends ConsumerWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ci serve lo stato del provider per visualizzare il nome e il sesso
    final user = ref.watch(userProvider);
    
    final name = user?.name ?? "";
    final sex = user?.sex ?? 1;
    final greeting = sex == 0 ? 'Benvenuta' : 'Benvenuto';

    return Text(
      name.isEmpty ? 'Benvenuto in CardioGuard!' : '$greeting, $name!',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }
}
