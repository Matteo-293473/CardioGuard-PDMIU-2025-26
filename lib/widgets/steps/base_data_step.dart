import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';

class BaseDataStep extends StatelessWidget {
  final TextEditingController ageController;
  final String sex;
  final String cp;
  final void Function(String) onSexChanged;
  final void Function(String) onCpChanged;

  const BaseDataStep({
    super.key,
    required this.ageController,
    required this.sex,
    required this.cp,
    required this.onSexChanged,
    required this.onCpChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        CustomTextField(
          controller: ageController, 
          label: 'Età', 
          icon: Icons.cake, 
          min: 10, 
          max: 120
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: sex,
          decoration: const InputDecoration(labelText: 'Sesso', prefixIcon: Icon(Icons.wc)),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          onChanged: (v) => onSexChanged(v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: cp,
          decoration: const InputDecoration(labelText: 'Tipo Dolore Toracico (CP)'),
          items: const [
            DropdownMenuItem(value: 'asymptomatic', child: Text('Asintomatico')),
            DropdownMenuItem(value: 'atypical angina', child: Text('Angina Atipica')),
            DropdownMenuItem(value: 'non-anginal', child: Text('Dolore Non Anginoso')),
            DropdownMenuItem(value: 'typical angina', child: Text('Angina Tipica')),
          ],
          onChanged: (v) => onCpChanged(v!),
        ),
      ],
    );
  }
}
