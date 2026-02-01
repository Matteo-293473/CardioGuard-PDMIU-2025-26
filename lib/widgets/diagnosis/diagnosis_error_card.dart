// card per la visualizzazione di errori durante la diagnosi
import 'package:flutter/material.dart';

class DiagnosisErrorCard extends StatelessWidget {
  final String error;
  final VoidCallback onClose;

  const DiagnosisErrorCard({
    super.key,
    required this.error,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline, 
              size: 48, 
              color: Theme.of(context).colorScheme.error
            ),
            const SizedBox(height: 16),
            Text(
              'Errore',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onClose,
                child: const Text('Chiudi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
