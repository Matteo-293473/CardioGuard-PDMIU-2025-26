import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'providers/providers.dart';
import 'widgets/settings/user_profile_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ascoltiamo il tema per aggiornare lo switch
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const UserProfileSection(),
            
            const SizedBox(height: 24),
            
            // sezione aspetto
            _buildSectionHeader(context, 'Aspetto'),
            Card(
              child: SwitchListTile(
                  title: const Text('Modalità Scura'),
                  subtitle: const Text('Abilita il tema scuro'),
                  secondary: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
                  value: isDark,
                  onChanged: (value) async {
                    await ref.read(themeProvider.notifier).toggleTheme();
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
