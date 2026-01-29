import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';

class UserProfileEditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final int sex;
  final void Function(int?) onSexChanged;

  const UserProfileEditForm({
    super.key,
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
            min: 10,
            max: 120,
            isInteger: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: sex,
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
