// overlay che gestisce i diversi stati (caricamento, successo, errore) della diagnosi
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/diagnosis_result.dart';
import 'diagnosis_loading_widget.dart';
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
    // caricamento
    if (diagnosisState.isLoading) {
      return const DiagnosisLoadingWidget();
    }

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
