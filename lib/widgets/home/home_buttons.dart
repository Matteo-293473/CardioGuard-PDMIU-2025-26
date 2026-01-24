import 'package:flutter/material.dart';
import '../../measurements_screen.dart';
import '../../app_constants.dart';
import '../../diagnosis_screen.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final measurementsButton = _buildHomeButton(
      context,
      isPortrait ? 'Le mie Misurazioni' : 'Misurazioni',
      Icons.monitor_heart_outlined,
      Colors.blue,
      () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const MeasurementsScreen()),
      ),
    );

    final aiButton = _buildHomeButton(
      context,
      'Analisi AI',
      Icons.analytics_outlined,
      Colors.red,
      () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DiagnosisScreen()),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isPortrait
          ? Column(
              children: [
                measurementsButton,
                const SizedBox(height: 12),
                aiButton,
              ],
            )
          : Row(
              children: [
                Expanded(child: measurementsButton),
                const SizedBox(width: 12),
                Expanded(child: aiButton),
              ],
            ),
    );
  }

  Widget _buildHomeButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0, // piatto -> stile moderno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius)
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
