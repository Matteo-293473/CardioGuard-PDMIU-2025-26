import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../providers/providers.dart';
import 'user_profile_read_info.dart';
import 'user_profile_edit_form.dart';

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
    final age = int.tryParse(_ageController.text);
    
    final newUser = User(
      name: name,
      age: age!, // non accetta null quindi forziamo
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
    final currentUser = ref.watch(userProvider);

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
                onPressed: () => _startEditing(currentUser),
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
             else // utente null (Creazione): Mostra solo il tasto Salva
               IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: _saveProfile,
                    tooltip: 'Salva Profilo',
               ),
          ],
        ),
        
        // contenuto: card di visualizzazione o form di modifica
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: showEditForm 
              ? UserProfileEditForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  ageController: _ageController,
                  sex: _sex,
                  onSexChanged: (val) => setState(() => _sex = val!),
                )
              : UserProfileReadInfo(user: currentUser),
          ),
        ),
      ],
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

