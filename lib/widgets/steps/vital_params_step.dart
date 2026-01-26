import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';

class VitalParamsStep extends StatelessWidget {
  final TextEditingController trestbpsController;
  final TextEditingController cholController;
  final String fbs;
  final void Function(String) onFbsChanged;

  const VitalParamsStep({
    super.key,
    required this.trestbpsController,
    required this.cholController,
    required this.fbs,
    required this.onFbsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        CustomTextField(
          controller: trestbpsController,
          label: 'Pressione Sistolica (Massima)',
          icon: Icons.speed,
          min: 50,
          max: 300
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: cholController, 
          label: 'Colesterolo', 
          icon: Icons.science, 
          min: 50, 
          max: 600
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: fbs,
          decoration: const InputDecoration(labelText: 'Glicemia > 120 mg/dl (FBS)'),
          items: const [
            DropdownMenuItem(value: 'false', child: Text('No')),
            DropdownMenuItem(value: 'true', child: Text('Sì')),
          ],
          onChanged: (v) => onFbsChanged(v!),
        ),
      ],
    );
  }
}
