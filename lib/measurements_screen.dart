import 'package:flutter/material.dart';
import 'app_constants.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxWidth < 600;
          
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
            // layout orizzontale
            // se lo schermo è molto grande (>1000), diamo più spazio al form (40%), altrimenti 350px
            final formWidth = constraints.maxWidth > AppConstants.bigScreenBreakpoint ? constraints.maxWidth * 0.4 : 350.0;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: formWidth,
                  child: const SingleChildScrollView(
                    child: MeasurementForm(),
                  ),
                ),
                const VerticalDivider(width: 1),
                const Expanded(
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
