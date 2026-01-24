import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../providers/providers.dart';
import '../common/custom_text_field.dart';

class UserProfileSection extends ConsumerStatefulWidget {
  const UserProfileSection({super.key});

  @override
  ConsumerState<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends ConsumerState<UserProfileSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  int _sex = 1; 
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

  // modifica profilo dopo aver clicato il tasto edit
  void _startEditing(User user) {
    _nameController.text = user.name;
    _ageController.text = user.age.toString();
    setState(() {
      _sex = user.sex;
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
  }


  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text) ?? 0;
    
    final newUser = User(
      name: name,
      age: age,
      sex: _sex,
    );

    await ref.read(userProvider.notifier).saveUser(newUser);

    // guardo se il widget è ancora presente 
    if (mounted) {
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        final currentUser = user;

        // se non c'è l'utente allora ci mettiamo in creazione
        final bool showEditForm = _isEditing || currentUser == null;

        return Column(
          children: [
            // bottoni dinamici nell'header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(context, 'Profilo Utente'),
                if (!showEditForm)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _startEditing(currentUser!),
                    tooltip: 'Modifica Profilo',
                    color: Theme.of(context).colorScheme.primary,
                  )
                else if (currentUser != null) 
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: _cancelEdit,
                        tooltip: 'Annulla',
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: _saveProfile,
                        tooltip: 'Salva',
                      ),
                    ],
                  )
                 else // utente null (Creazione): Mostra solo il tasto Salva (o nulla se il form ha il suo bottone, ma qui usiamo il tasto header per consistenza)
                   IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: _saveProfile,
                        tooltip: 'Salva Profilo',
                   ),
              ],
            ),
            
            // Contenuto: Card di visualizzazione o Form di modifica
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: showEditForm 
                  ? _EditForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      ageController: _ageController,
                      sex: _sex,
                      onSexChanged: (val) => setState(() => _sex = val!),
                    )
                  : _ReadInfo(user: currentUser!),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Errore: $err')),
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



class _ReadInfo extends StatelessWidget {
  final User user;
  const _ReadInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.person),
          title: const Text("Nome"),
          subtitle: Text(user.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cake),
                title: const Text("Età"),
                subtitle: Text("${user.age} anni"),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.wc),
                title: const Text("Sesso"),
                subtitle: Text(user.sex == 1 ? "Maschio" : "Femmina"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final int sex;
  final ValueChanged<int?> onSexChanged;

  const _EditForm({
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.sex,
    required this.onSexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: nameController,
            label: 'Nome',
            maxLength: 20,
            onlyText: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: ageController,
            label: 'Età',
            min: 14,
            max: 120,
            isInteger: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: sex,
            decoration: const InputDecoration(labelText: 'Sesso'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Maschio')),
              DropdownMenuItem(value: 0, child: Text('Femmina')),
            ],
            onChanged: onSexChanged,
          ),
          const SizedBox(height: 24),
          const Text(
            'Stai modificando il tuo profilo...',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
