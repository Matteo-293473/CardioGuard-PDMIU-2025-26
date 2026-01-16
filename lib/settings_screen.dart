import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'data/models/user.dart';
import 'providers/providers.dart';
import 'services/notification_service.dart';

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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
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
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profilo aggiornato con successo!')),
        );
      }
    }
  }

  void _cancelEdit() {
    final user = ref.read(userProvider).value;
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      setState(() {
        _sex = user.sex;
        _isEditing = false;
      });
    } else {
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ascoltiamo il tema per aggiornare lo switch
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    
    // Ascoltiamo l'utente (AsyncValue) per la UI
    final userAsync = ref.watch(userProvider);

    // Gestione dell'inizializzazione dei dati (Lezione 10A/B best practice)
    // Se abbiamo dati e i controller sono vuoti, popoliamo subito in build
    if (userAsync.hasValue && userAsync.value != null && _nameController.text.isEmpty) {
      final user = userAsync.value!;
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _sex = user.sex;
    }

    // Continuiamo ad ascoltare per aggiornamenti esterni (es. reset o sync)
    ref.listen<AsyncValue<User?>>(userProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && _nameController.text.isEmpty) {
          _nameController.text = user.name;
          _ageController.text = user.age.toString();
          setState(() {
            _sex = user.sex;
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Modifica Profilo',
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelEdit,
              tooltip: 'Annulla',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
              tooltip: 'Salva',
            ),
          ],
        ],
      ),
      body: userAsync.when(
        data: (user) {
          return SingleChildScrollView(
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
                            enabled: _isEditing,
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
                            enabled: _isEditing,
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
                            onChanged: _isEditing ? (value) {
                              if (value != null) {
                                setState(() => _sex = value);
                              }
                            } : null,
                          ),
                          if (_isEditing) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Stai modificando il tuo profilo...',
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ],
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
                const SizedBox(height: 24),
                if (defaultTargetPlatform == TargetPlatform.android) ...[
                  _buildSectionHeader('Notifiche'),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Promemoria Pressione'),
                      subtitle: const Text('Ricevi una notifica ogni giorno alle 20:00'),
                      secondary: const Icon(Icons.notifications_active),
                      value: ref.watch(notificationProvider),
                      onChanged: (value) async {
                        final messenger = ScaffoldMessenger.of(context);
                        await ref.read(notificationProvider.notifier).toggleNotifications();
                        if (mounted) {
                          final isEnabled = ref.read(notificationProvider);
                          messenger.showSnackBar(
                            SnackBar(content: Text(isEnabled ? 'Notifiche attivate' : 'Notifiche disattivate')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.notification_important, color: Colors.orange),
                      title: const Text('Invia Notifica di Test'),
                      subtitle: const Text('Premi per verificare se le notifiche funzionano'),
                      onTap: () async {
                        await NotificationService().showTestNotification();
                      },
                    ),
                  ),
                ],
                
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
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
