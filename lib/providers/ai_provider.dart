// provider per la gestione della diagnosi tramite servizio classificazione backend
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../data/models/diagnosis_result.dart';
import '../data/models/diagnosis_input.dart';

import '../app_constants.dart';

// provider per il servizio AI
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

// controller per la diagnosi  
class DiagnosisController extends AsyncNotifier<DiagnosisResult?> {
  @override
  DiagnosisResult? build() {
    return null;
  }

  Future<void> runDiagnosis(DiagnosisInput input) async {
    state = const AsyncValue.loading();
    try {
      final aiService = ref.read(aiServiceProvider);
      
      // chiamata con timeout 
      final result = await aiService.predictDisease(
        age: input.age,
        trestbps: input.trestbps,
        chol: input.chol,
        thalch: input.thalach,
        oldpeak: input.oldpeak,
        sex: input.sex,
        cp: input.cp,
        fbs: input.fbs,
        restecg: input.restecg,
        exang: input.exang,
        slope: input.slope,
        thal: input.thal,
        ca: input.ca,
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds), onTimeout: () {
        throw 'Timeout: Il server ci sta mettendo troppo. Riprova, ora dovrebbe essere attivo.';
      });

      state = AsyncValue.data(result);
    } catch (e, stack) {
      String message;
      if (e.toString().contains('Timeout')) {
        message = 'Il server sta impiegando troppo tempo. Riprova tra poco.';
      } else {
        message = 'Errore di connessione. Riprova più tardi.';
      }
      state = AsyncValue.error(message, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final diagnosisControllerProvider = AsyncNotifierProvider<DiagnosisController, DiagnosisResult?>(() {
  return DiagnosisController();
});
