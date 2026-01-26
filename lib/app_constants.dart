class AppConstants {
  // Configurazione Backend
  static const String apiBaseUrl = 'https://cardioguard-backend-v1.onrender.com';
  
  // Secondi timeout 
  static const int apiTimeoutSeconds = 90;

  // APIs
  // airQuality
  static const String airQualityApiUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';
  static const int airQualityTimeoutSeconds = 10;

  // geocoding
  static const String geocodingApiUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const int geocodingTimeoutSeconds = 5;

  // Backend
  static const String appUserAgent = 'CardioGuard-App/1.0';

  // UI 
  static const double defaultRadius = 15.0;
  static const double bigScreenBreakpoint = 1000.0;
}
