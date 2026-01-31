// servizio per il reverse geocoding (OpenStreetMap Nominatim API)
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_constants.dart';

class GeocodingService {
  static Future<String?> getCityName(double lat, double lon) async {
    try {
      final geoUrl = Uri.parse(
          '${AppConstants.geocodingApiUrl}?format=json&lat=$lat&lon=$lon&zoom=10&addressdetails=1');
      
      final geoResponse = await http.get(geoUrl, headers: {
        'User-Agent': AppConstants.appUserAgent, // Nominatim richiede questo tipo di header
      }).timeout(const Duration(seconds: AppConstants.geocodingTimeoutSeconds));

      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        final address = geoData['address'];
        if (address != null) {
          return address['city'] ?? 
                 address['town'] ?? 
                 address['village'] ?? 
                 address['municipality'] ?? 
                 address['county'];
        }
      }
    } catch (e) {
      // in caso di errore, ritorniamo null
    }
    return null;
  }
}
