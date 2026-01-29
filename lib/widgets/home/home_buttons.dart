import 'package:flutter/material.dart';
import '../../measurements_screen.dart';
import '../../app_constants.dart';
import '../../diagnosis_screen.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final measurementsButton = _buildHomeButton(
      context,
      isLandscape ? 'Le mie Misurazioni' : 'Misurazioni',
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
      child: isLandscape
          ? Row(
              children: [
                Expanded(child: measurementsButton),
                const SizedBox(width: 24),
                Expanded(child: aiButton),
              ],
            )
          : Column(
              children: [
                measurementsButton,
                const SizedBox(height: 12),
                aiButton,
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
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius)),
      ),
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
