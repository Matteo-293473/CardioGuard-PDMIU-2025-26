// schermata delle impostazioni per gestire il profilo utente e le preferenze grafiche.
import 'package:flutter/material.dart';
import 'widgets/settings/user_profile_section.dart';
import 'widgets/settings/theme_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
