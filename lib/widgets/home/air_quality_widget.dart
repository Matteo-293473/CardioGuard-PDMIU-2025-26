import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/air_quality_provider.dart';
import '../../app_constants.dart';

class AirQualityWidget extends ConsumerWidget {
  const AirQualityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqAsync = ref.watch(airQualityProvider);

    return aqAsync.when(
      data: (aq) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getAqiColor(aq.aqi).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          border: Border.all(color: _getAqiColor(aq.aqi), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, color: _getAqiColor(aq.aqi)),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  aq.city != null ? 'Qualità aria - ${aq.city}' : 'Qualità dell\'aria',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  aq.description,
                  style: TextStyle(
                    color: _getAqiColor(aq.aqi),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      // errore generico
      error: (_, __) => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text('Dati non disponibili', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }


  Color _getAqiColor(int aqi) {
    const colors = [
      Colors.green,      
      Colors.lightGreen, 
      Colors.yellow,     
      Colors.orange,     
      Colors.red,        
      Colors.purple,
    ];
    // se aqi è valido -> colore, altrimenti grigio
    if (aqi >= 1 && aqi <= colors.length) return colors[aqi - 1];
    return Colors.grey;
  }
}
