// schermata per inserimento e visualizzazione storico misurazioni
import 'package:flutter/material.dart';
import 'widgets/measurements/measurement_form.dart';
import 'widgets/measurements/measurements_list.dart';


class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie Misurazioni'),
      ),
      body: isPortrait
          ? const Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: MeasurementForm(),
                  ),
                ),
                Divider(height: 1),
                Expanded(
                  child: MeasurementsList(),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  child: const SingleChildScrollView(
                    child: MeasurementForm(),
                  ),
                ),
                const VerticalDivider(width: 1),
                const Expanded(
                  child: MeasurementsList(),
                ),
              ],
            ),
    );
  }
}
