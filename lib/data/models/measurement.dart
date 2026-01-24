class Measurement {
  final int? id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime timestamp;

  Measurement({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.timestamp,
  });


  // Trasforma una mappa dal database in un oggetto Dart 
  factory Measurement.fromMap(Map<String, dynamic> map) {
    return Measurement(
      id: map['id'] as int?,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      pulse: map['pulse'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  // Metodo toMap. Ci serve per inserire i dati nel database
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
