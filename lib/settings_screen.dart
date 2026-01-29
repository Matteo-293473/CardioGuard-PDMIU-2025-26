import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/settings/user_profile_section.dart';
import 'widgets/settings/theme_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // sezione profilo utente
            const UserProfileSection(),
            
            const SizedBox(height: 24),
            
            // sezione tema
            const ThemeSection(),
          ],
        ),
      ),
    );
  }
}
