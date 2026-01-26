import 'package:flutter/material.dart';

class AdvancedExamsStep extends StatelessWidget {
  final String restecg;
  final String exang;
  final String thal;
  final int ca;
  final void Function(String) onRestecgChanged;
  final void Function(String) onExangChanged;
  final void Function(String) onThalChanged;
  final void Function(int) onCaChanged;

  const AdvancedExamsStep({
    super.key,
    required this.restecg,
    required this.exang,
    required this.thal,
    required this.ca,
    required this.onRestecgChanged,
    required this.onExangChanged,
    required this.onThalChanged,
    required this.onCaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: restecg,
          decoration: const InputDecoration(labelText: 'ECG a Riposo'),
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normale')),
            DropdownMenuItem(value: 'st-t abnormality', child: Text('Anomalia ST-T')),
            DropdownMenuItem(value: 'lv hypertrophy', child: Text('Ipertrofia Ventricolare')),
          ],
          onChanged: (v) => onRestecgChanged(v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: exang,
          decoration: const InputDecoration(labelText: 'Angina da Sforzo'),
          items: const [
            DropdownMenuItem(value: 'false', child: Text('No')),
            DropdownMenuItem(value: 'true', child: Text('Sì')),
          ],
          onChanged: (v) => onExangChanged(v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: ca,
          decoration: const InputDecoration(labelText: 'Vasi Colorati (CA)'),
          items: const [
            DropdownMenuItem(value: 0, child: Text('0')),
            DropdownMenuItem(value: 1, child: Text('1')),
            DropdownMenuItem(value: 2, child: Text('2')),
            DropdownMenuItem(value: 3, child: Text('3')),
          ],
          onChanged: (v) => onCaChanged(v!),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: thal,
          decoration: const InputDecoration(labelText: 'Talassemia'),
          items: const [
            DropdownMenuItem(value: 'normal', child: Text('Normale')),
            DropdownMenuItem(value: 'fixed defect', child: Text('Difetto Fisso')),
            DropdownMenuItem(value: 'reversable defect', child: Text('Difetto Reversibile')),
          ],
          onChanged: (v) => onThalChanged(v!),
        ),
      ],
    );
  }
}
