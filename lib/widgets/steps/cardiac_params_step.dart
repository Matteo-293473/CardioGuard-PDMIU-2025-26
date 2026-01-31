// step 3 frequenza max, depressione ST
import 'package:flutter/material.dart';
import '../common/custom_text_field.dart';

class CardiacParamsStep extends StatelessWidget {
  final TextEditingController thalachController;
  final TextEditingController oldpeakController;
  final String slope;
  final void Function(String) onSlopeChanged;

  const CardiacParamsStep({
    super.key,
    required this.thalachController,
    required this.oldpeakController,
    required this.slope,
    required this.onSlopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        CustomTextField(
          controller: thalachController, 
          label: 'Frequenza Max (Thalach)', 
          icon: Icons.favorite, 
          min: 30, 
          max: 250
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: oldpeakController, 
          label: 'Depressione ST (Oldpeak)', 
          icon: Icons.show_chart, 
          min: 0.0, 
          max: 10.0
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: slope,
          decoration: const InputDecoration(labelText: 'Pendenza ST (Slope)'),
          items: const [
            DropdownMenuItem(value: 'flat', child: Text('Piatta (Flat)')),
            DropdownMenuItem(value: 'upsloping', child: Text('In Salita (Up)')),
            DropdownMenuItem(value: 'downsloping', child: Text('In Discesa (Down)')),
          ],
          onChanged: (v) => onSlopeChanged(v!),
        ),
      ],
    );
  }
}
