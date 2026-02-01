// overlay che gestisce i diversi stati (caricamento, successo, errore) della diagnosi
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/diagnosis_result.dart';
import 'diagnosis_result_card.dart';
import 'diagnosis_error_card.dart';

class DiagnosisOverlay extends StatelessWidget {
  final AsyncValue<DiagnosisResult?> diagnosisState;
  final VoidCallback onReset;
  final VoidCallback onRetry;

  const DiagnosisOverlay({
    super.key,
    required this.diagnosisState,
    required this.onReset,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // successo
    if (diagnosisState.hasValue && diagnosisState.value != null) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DiagnosisResultCard(result: diagnosisState.value!),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nuova Analisi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // caricamento
    if (diagnosisState.isLoading) {
      return Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Analisi AI in corso...',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Attendi qualche secondo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // errore
    if (diagnosisState.hasError) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: DiagnosisErrorCard(
              error: diagnosisState.error.toString(),
              onRetry: onRetry,
            ),
          ),
        ),
      );
    }

    // nulla  
    return const SizedBox.shrink();
  }
}
