import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../data/models/air_quality.dart';
import '../app_constants.dart';

class AirQualityService {
  static Future<AirQuality> fetchAirQuality(double lat, double lon) async {
    final url = Uri.parse(
        '${AppConstants.airQualityApiUrl}?latitude=$lat&longitude=$lon&current=us_aqi');
    
    String? cityName;
    try {
      // usiamo Nominatim per avere il nome della città da lat e lon
      final geoUrl = Uri.parse(
          '${AppConstants.geocodingApiUrl}?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1');
      
      final geoResponse = await http.get(geoUrl, headers: {
        'User-Agent': AppConstants.appUserAgent, // Nominatin richieste questo tipo di header
      }).timeout(const Duration(seconds: AppConstants.geocodingTimeoutSeconds));

      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        final address = geoData['address'];
        if (address != null) {
          cityName = address['city'] ?? address['town'] ?? address['village'] ?? address['municipality'] ?? address['county'];
        }
      }
    } catch (e) {
      // ignoriamo gli errori di geocoding
    }

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
