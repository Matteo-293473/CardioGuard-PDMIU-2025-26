import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../data/models/diagnosis_result.dart';
import '../data/models/diagnosis_input.dart';

import '../app_constants.dart';

// 8. Provider per il servizio AI
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

// 9. Controller per la diagnosi (Logic + State)
class DiagnosisController extends AsyncNotifier<DiagnosisResult?> {
  @override
  DiagnosisResult? build() {
    return null;
  }

  Future<void> runDiagnosis(DiagnosisInput input) async {
    state = const AsyncValue.loading();
    try {
      final aiService = ref.read(aiServiceProvider);
      
      // Chiamata con Timeout gestita qui
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
        message = e.toString().replaceFirst('Exception: ', '');
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
