import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/models/diagnosis_result.dart';

import '../app_constants.dart';

class AIService {
  
  // Indirizzo dove è situato il nostro backend python
  final String _baseUrl = AppConstants.apiBaseUrl; // cardiogurd BE

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
    final body = jsonEncode({
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
    });

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 90)); 


      if (response.statusCode == 200) {
        return DiagnosisResult.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Errore ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
