class AirQuality {
  final int aqi;
  final String description;
  final double? lat;
  final double? lon;
  final String? city;

  AirQuality({
    required this.aqi,
    required this.description,
    this.lat,
    this.lon,
    this.city,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json, {double? lat, double? lon, String? city}) {
    final rawAqi = json['current']['us_aqi'] as int;
    
    String desc;
    int category;

    if (rawAqi <= 50) {
      desc = 'Ottima';
      category = 1;
    } else if (rawAqi <= 100) {
      desc = 'Buona';
      category = 2;
    } else if (rawAqi <= 150) {
      desc = 'Moderata';
      category = 3;
    } else if (rawAqi <= 200) {
      desc = 'Scarsa';
      category = 4;
    } else if (rawAqi <= 300) {
      desc = 'Molto Scarsa';
      category = 5;
    } else {
      desc = 'Pessima';
      category = 6;
    }
    
    return AirQuality(
      aqi: category,
      description: '$desc ($rawAqi)',
      lat: lat ?? (json['latitude'] as num?)?.toDouble(),
      lon: lon ?? (json['longitude'] as num?)?.toDouble(),
      city: city,
    );
  }
}
