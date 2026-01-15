import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/models/diagnosis_result.dart';

class AIService {
  
  // Indirizzo in produzione a cui faremo le nostre richieste (render)
  final String _baseUrl = 'https://cardioguard-backend-v1.onrender.com';

  Future<DiagnosisResult> predictDisease({
    required int age,
    required int trestbps, // Pressione
    required int chol, // Colesterolo
    required int thalch, // Freq cardiaca max
    required double oldpeak, // Depressione ST
    required String sex, // Sesso
    required String cp, // Tipo dolore petto
    required String fbs, // Fasting Blood Sugar
    required String restecg, // Rest ECG
    required String exang, // Exercise Angina
    required String slope, // ST Slope
    required String thal, // Thalassemia
    required int ca, // Number of vessels
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'age': age,
        'trestbps': trestbps,
        'chol': chol,
        'thalch': thalch,
        'oldpeak': oldpeak,
        'sex': sex,
        'cp': cp,
        'fbs': fbs,
        'restecg': restecg,
        'exang': exang,
        'slope': slope,
        'thal': thal,
        'ca': ca,
      }),
    ).timeout(const Duration(seconds: 15)); // Timeout di 15 secondi

    if (response.statusCode == 200) {
      // Parsing JSON pulito nel modello
      return DiagnosisResult.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('Errore API (${response.statusCode}): ${response.body}');
      throw Exception('Errore ${response.statusCode}: ${response.body}');
    }
  }
}
