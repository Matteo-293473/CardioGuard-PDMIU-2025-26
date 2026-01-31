// servizio per il recupero dei dati sulla qualità dell'aria (Open-Meteo API)
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'geocoding_service.dart';
import '../data/models/air_quality.dart';
import '../app_constants.dart';

class AirQualityService {
  static Future<AirQuality> fetchAirQuality(double lat, double lon) async {
    final url = Uri.parse(
        '${AppConstants.airQualityApiUrl}?latitude=$lat&longitude=$lon&current=us_aqi');
    
    // Otteniamo il nome della città usando il servizio dedicato
    String? cityName = await GeocodingService.getCityName(lat, lon);

    // qui abbiamo la città. Ora dobbiamo ricavare le informazioni relative all'aria
    try {
      final response = await http.get(url).timeout(const Duration(seconds: AppConstants.airQualityTimeoutSeconds)); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AirQuality.fromJson(
          data, 
          lat: lat, 
          lon: lon, 
          city: cityName
        );
      } else {
        throw Exception('Errore API (${response.statusCode})');
      }
    } catch (e) {
      // In caso di errore API, restituiamo un oggetto vuoto che il widget gestirà
      return AirQuality(aqi: 0, description: 'Dati non disponibili', city: cityName);
    }
  }
}
