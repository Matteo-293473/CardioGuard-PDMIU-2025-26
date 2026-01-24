import 'package:flutter/material.dart';
import '../../data/models/diagnosis_result.dart';
import '../../app_constants.dart';

class DiagnosisResultCard extends StatelessWidget {
  final DiagnosisResult result;

  const DiagnosisResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthy = !result.hasDisease;
    final color = isHealthy ? Colors.green : Colors.red;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.defaultRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  size: 64,
                  color: color,
                ),
                const SizedBox(height: 16),
                Text(
                  result.interpretation,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isHealthy) // Solo se c'è rischio
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '(Possibile presenza di patologia)',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: color),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Attendibilità: ${(result.confidence * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 17,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
