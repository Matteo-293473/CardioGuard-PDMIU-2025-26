// form inserimento manuale misurazione
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/measurement.dart';
import '../../providers/providers.dart';
import '../common/custom_text_field.dart';
import '../../app_constants.dart';

class MeasurementForm extends ConsumerStatefulWidget {
  const MeasurementForm({super.key});

  @override
  ConsumerState<MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends ConsumerState<MeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController(text: '120');
  final _diastolicController = TextEditingController(text: '80');
  final _pulseController = TextEditingController(text: '70');

  Future<void> _saveMeasurement() async {
    if (_formKey.currentState!.validate()) {
      final measurement = Measurement(
        systolic: (double.tryParse(_systolicController.text) ?? 0).round(),
        diastolic: (double.tryParse(_diastolicController.text) ?? 0).round(),
        pulse: (double.tryParse(_pulseController.text) ?? 0).round(),
        timestamp: DateTime.now(),
      );

      await ref.read(measurementListProvider.notifier).addMeasurement(measurement);

      // pulizia campi dopo salvataggio
      _systolicController.clear();
      _diastolicController.clear();
      _pulseController.clear();
    }
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nuova Misurazione',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _systolicController, 
                      label: 'Sistolica', 
                      suffixText: 'mmHg',
                      min: 50,
                      max: 300,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _diastolicController, 
                      label: 'Diastolica', 
                      suffixText: 'mmHg',
                      min: 30,
                      max: 200,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _pulseController, 
                      label: 'Battito (BPM)', 
                      suffixText: 'bpm',
                      min: 30,
                      max: 250,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saveMeasurement,
                icon: const Icon(Icons.add),
                label: const Text('Aggiungi Misurazione'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
