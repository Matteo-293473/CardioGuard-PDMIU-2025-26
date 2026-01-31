// modello per il risultato della diagnosi + metodo che converte il risultato in stringa
class DiagnosisResult {
  final bool hasDisease; 
  final double confidence; 

  DiagnosisResult({
    required this.hasDisease,
    required this.confidence,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    // label code > 0 significa malato
    final int labelCode = json['class_label'] as int;
    final bool isSick = labelCode > 0;

    return DiagnosisResult(
      hasDisease: isSick,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  String get interpretation {
    if (hasDisease) {
      return "Alto Rischio";
    }
    return "Basso Rischio";
  }
}
