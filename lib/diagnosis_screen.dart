import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/providers.dart';
import 'data/models/diagnosis_input.dart';
import 'widgets/diagnosis/diagnosis_overlay.dart';
import 'widgets/steps/base_data_step.dart';
import 'widgets/steps/vital_params_step.dart';
import 'widgets/steps/cardiac_params_step.dart';
import 'widgets/steps/advanced_exams_step.dart';

class DiagnosisScreen extends ConsumerStatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  ConsumerState<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends ConsumerState<DiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  int _controlsStep = 0;
  bool _isAnimating = false;
  bool _prefilledFromUser = false;
  
  // Controllers
  late TextEditingController _ageController;
  late TextEditingController _trestbpsController;
  late TextEditingController _cholController;
  late TextEditingController _thalchController;
  late TextEditingController _oldpeakController;
  
  // Ivalori di inizializzazione
  String _sex = 'Male';
  String _cp = 'asymptomatic';
  String _fbs = 'false';
  String _restecg = 'normal';
  String _exang = 'false';
  String _slope = 'flat';
  String _thal = 'normal';
  int _ca = 0;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: '45');
    _trestbpsController = TextEditingController(text: '120');
    _cholController = TextEditingController(text: '200');
    _thalchController = TextEditingController(text: '150');
    _oldpeakController = TextEditingController(text: '1.0');
    

    final user = ref.read(userProvider);
    if (user != null && !_prefilledFromUser) {
      _ageController.text = user.age.toString();
      _sex = user.sex == 1 ? 'Male' : 'Female';
      _prefilledFromUser = true;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _trestbpsController.dispose();
    _cholController.dispose();
    _thalchController.dispose();
    _oldpeakController.dispose();
    super.dispose();
  }

  void _submitDiagnosis() {
    final input = DiagnosisInput.fromControllers(
      age: _ageController,
      trestbps: _trestbpsController, 
      chol: _cholController, 
      thalach: _thalchController, 
      oldpeak: _oldpeakController, 
      sex: _sex, 
      cp: _cp, 
      fbs: _fbs, 
      restecg: _restecg, 
      exang: _exang, 
      slope: _slope, 
      thal: _thal, 
      ca: _ca
    );
    
    ref.read(diagnosisControllerProvider.notifier).runDiagnosis(input);
  }

  void _resetForm() {
    ref.read(diagnosisControllerProvider.notifier).reset();
    setState(() {
      _currentStep = 0;
      _controlsStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final diagnosisState = ref.watch(diagnosisControllerProvider);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: const Text('Analisi AI')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Stepper(
                    type: isPortrait ? StepperType.vertical : StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepTapped: (step) {
                      if (_isAnimating) return;
                      // permette di saltare solo ai passi già visitati o 
                      // al passo successivo se validato
                      setState(() {
                        _currentStep = step;
                        _controlsStep = step;
                      });
                    },
                    onStepContinue: () async {
                      if (_isAnimating) return;
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_currentStep < 3) {
                          setState(() {
                            _currentStep++;
                            _isAnimating = true;
                          });
                          await Future.delayed(const Duration(milliseconds: 300));
                          if (mounted) {
                            setState(() {
                              _controlsStep = _currentStep;
                              _isAnimating = false;
                            });
                          }
                        } else {
                          // submit form
                          _submitDiagnosis();
                        }
                      }
                    },
                    onStepCancel: () async {
                      if (_isAnimating) return;
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep--;
                          _isAnimating = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (mounted) {
                          setState(() {
                            _controlsStep = _currentStep;
                            _isAnimating = false;
                          });
                        }
                      }
                    },
                    controlsBuilder: (context, details) {
                       // Custom controls to handle animation delay or specific styling if needed
                       if (_currentStep != _controlsStep) return const SizedBox.shrink();
                       
                       return Padding(
                         padding: const EdgeInsets.only(top: 20.0),
                         child: Row(
                           children: [
                             FilledButton(
                               style: FilledButton.styleFrom(
                                 minimumSize: const Size(0, 48),
                               ),
                               onPressed: details.onStepContinue,
                               child: Text(_currentStep == 3 ? 'Calcola Rischio' : 'Continua'),
                             ),
                             if (_currentStep > 0) ...[
                               const SizedBox(width: 12),
                               TextButton(
                                 onPressed: details.onStepCancel,
                                 child: const Text('Indietro'),
                               ),
                             ],
                           ],
                         ),
                       );
                    },
                    steps: [
                      Step(
                        title: const Text('Dati Base'),
                        isActive: _currentStep >= 0,
                        content: BaseDataStep(
                          ageController: _ageController,
                          sex: _sex,
                          cp: _cp,
                          onSexChanged: (v) => setState(() => _sex = v),
                          onCpChanged: (v) => setState(() => _cp = v),
                        ),
                      ),
                      Step(
                        title: const Text('Vitali'),
                        isActive: _currentStep >= 1,
                        content: VitalParamsStep(
                          trestbpsController: _trestbpsController,
                          cholController: _cholController,
                          fbs: _fbs,
                          onFbsChanged: (v) => setState(() => _fbs = v),
                        ),
                      ),
                      Step(
                        title: const Text('Cardiaci'),
                        isActive: _currentStep >= 2,
                        content: CardiacParamsStep(
                          thalachController: _thalchController,
                          oldpeakController: _oldpeakController,
                          slope: _slope,
                          onSlopeChanged: (v) => setState(() => _slope = v),
                        ),
                      ),
                      Step(
                        title: const Text('Avanzati'),
                        isActive: _currentStep >= 3,
                        content: AdvancedExamsStep(
                          restecg: _restecg,
                          exang: _exang,
                          ca: _ca,
                          thal: _thal,
                          onRestecgChanged: (v) => setState(() => _restecg = v),
                          onExangChanged: (v) => setState(() => _exang = v),
                          onCaChanged: (v) => setState(() => _ca = v),
                          onThalChanged: (v) => setState(() => _thal = v),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // overlay per loading - success - error
          DiagnosisOverlay(
            diagnosisState: diagnosisState, 
            onReset: _resetForm, 
            onRetry: () => ref.read(diagnosisControllerProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }
}
