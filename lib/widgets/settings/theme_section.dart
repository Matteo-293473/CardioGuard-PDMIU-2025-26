// widget impostazioni tema
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../common/header_section.dart';

class ThemeSection extends ConsumerWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // themeProvider per impostare il valore dello SwitchListTile 
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderSection(title: 'Aspetto'),
        Card(
          child: SwitchListTile(
            title: const Text('Modalità Scura'),
            subtitle: const Text('Abilita il tema scuro'),
            secondary: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
            value: isDark, // dal provider
            onChanged: (value) async {
              // cambio tema tramite provider
              await ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ),
      ],
    );
  }
}
