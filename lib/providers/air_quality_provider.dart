// provider per la gestione della posizione GPS e dei dati sulla qualità dell'aria
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/air_quality_service.dart';
import '../data/models/air_quality.dart';

// sezione relativa alla posizione dell'utente
final locationProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) throw Exception('Servizi di localizzazione disabilitati');

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) throw Exception('Permessi negati');
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
});


// sezione relativa alla qualità dell'aria in base alla posizione dell'utente
final airQualityProvider = FutureProvider<AirQuality>((ref) async {

  Future<AirQuality> getAirQuality() async {
    // otteniamo la posizione
    final pos = await ref.watch(locationProvider.future);
    
    // chiamiamo l'API
    return await AirQualityService.fetchAirQuality(pos.latitude, pos.longitude);
  }

  // applichiamo il timeout a GPS e API insieme
  return await getAirQuality().timeout(
    const Duration(seconds: 10),
    onTimeout: () {
      throw Exception('Timeout totale (10s)');
    },
  );
});
