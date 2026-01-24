import 'package:flutter/material.dart';
import 'widgets/measurements/measurement_form.dart';
import 'widgets/measurements/measurements_list.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie Misurazioni'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          
          if (isPortrait) {
            return const Column(
              children: [
                SingleChildScrollView(
                  child: MeasurementForm(),
                ),
                Divider(height: 1),
                Expanded(
                  child: MeasurementsList(),
                ),
              ],
            );
          } else {
            // layout orizzontale: form a sinistra, lista a destra
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350, // larghezza fissa per il form
                  child: SingleChildScrollView(
                    child: MeasurementForm(),
                  ),
                ),
                VerticalDivider(width: 1),
                Expanded(
                  child: MeasurementsList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
