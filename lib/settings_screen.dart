import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/models/user.dart';
import 'providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  int _sex = 1; // 1: Male, 0: Female

  @override
  void initState() {
    super.initState();
    // Inizializziamo i controller con i dati dell'utente, se presenti
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
    _sex = user?.sex ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = int.tryParse(_ageController.text) ?? 0;
      
      final newUser = User(
        name: name,
        age: age,
        sex: _sex,
      );

      // Salviamo l'utente tramite il provider
      await ref.read(userProvider.notifier).saveUser(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profilo aggiornato con successo!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ascoltiamo il tema per aggiornare lo switch
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
            _buildSectionHeader('Profilo Utente'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci un nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        decoration: const InputDecoration(labelText: 'Età'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci la tua età';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Inserisci un numero valido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _sex,
                        decoration: const InputDecoration(labelText: 'Sesso'),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Maschio')),
                          DropdownMenuItem(value: 0, child: Text('Femmina')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sex = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _saveProfile,
                        child: const Text('Salva Profilo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Aspetto'),
            Card(
              child: SwitchListTile(
                  title: const Text('Modalità Scura'),
                  subtitle: const Text('Abilita il tema scuro'),
                  secondary: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny),
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
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
