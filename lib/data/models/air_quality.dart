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

  factory AirQuality.fromJson(Map<String, dynamic> json, [double? lat, double? lon, String? city]) {
    final rawAqi = json['current']['us_aqi'] as int;
    
    final (desc, category) = switch (rawAqi) {
      <= 50 => ('Ottima', 1),
      <= 100 => ('Buona', 2),
      <= 150 => ('Moderata', 3),
      <= 200 => ('Scarsa', 4),
      <= 300 => ('Molto Scarsa', 5),
      _ => ('Pessima', 6),
    };
    
    return AirQuality(
      aqi: category,
      description: '$desc ($rawAqi)',
      lat: lat ?? (json['latitude'] as num?)?.toDouble(),
      lon: lon ?? (json['longitude'] as num?)?.toDouble(),
      city: city,
    );
  }
}
