// schermata per analisi AI con stepper
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
  // una globalkey per ogni step
  // questo serve per validare ogni step separatamente prima di procedere
  final List<GlobalKey<FormState>> _stepFormKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  
  int _currentStep = 0;
  
  // controller
  late TextEditingController _ageController;
  late TextEditingController _trestbpsController;
  late TextEditingController _cholController;
  late TextEditingController _thalchController;
  late TextEditingController _oldpeakController;
  
  // valori di inizializzazione
  String _sex = 'Male';
  String _cp = 'asymptomatic';
  String _fbs = 'false';
  String _restecg = 'normal';
  String _exang = 'false';
  String _slope = 'flat';
  String _thal = 'normal';
  int _ca = 0;


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
            child: Theme(
              data: Theme.of(context).copyWith(
                // rimuovo effettivi 
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Stepper(
                    type: isPortrait ? StepperType.vertical : StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      // validazione sullo step corrente
                      if (_stepFormKeys[_currentStep].currentState?.validate() ?? false) {
                        if (_currentStep < 3) {
                          // ci sono altri step
                          setState(() {
                            _currentStep += 1;
                          });
                        } else {
                          // qui siamo nell'ultimo step quindi inviamo la diagnosi
                          _submitDiagnosis();
                        }
                      }
                    },
                    onStepCancel: () {
                      // torno indietro se posso
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      } else {
                         Navigator.of(context).pop();
                      }
                    },
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                ),
                                onPressed: details.onStepContinue,
                                child: Text(_currentStep == 3 ? 'Analizza' : 'Continua'),
                              ),
                            ),

                            if (_currentStep > 0) const SizedBox(width: 16),

                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  onPressed: details.onStepCancel,
                                  child: const Text('Indietro'),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Dati Base'),
                        content: Form(
                          key: _stepFormKeys[0],
                          child: BaseDataStep(
                            ageController: _ageController,
                            sex: _sex,
                            cp: _cp,
                            onSexChanged: (newValue) => setState(() => _sex = newValue),
                            onCpChanged: (newValue) => setState(() => _cp = newValue),
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Vitali'),
                        content: Form(
                          key: _stepFormKeys[1],
                          child: VitalParamsStep(
                            trestbpsController: _trestbpsController,
                            cholController: _cholController,
                            fbs: _fbs,
                            onFbsChanged: (newValue) => setState(() => _fbs = newValue),
                          ),
                        ),
                        isActive: _currentStep >= 1,
                        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Cardiaci'),
                        content: Form(
                          key: _stepFormKeys[2],
                          child: CardiacParamsStep(
                            thalachController: _thalchController,
                            oldpeakController: _oldpeakController,
                            slope: _slope,
                            onSlopeChanged: (newValue) => setState(() => _slope = newValue),
                          ),
                        ),
                        isActive: _currentStep >= 2,
                        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Avanzati'),
                        content: Form(
                          key: _stepFormKeys[3],
                          child: AdvancedExamsStep(
                            restecg: _restecg,
                            exang: _exang,
                            thal: _thal,
                            ca: _ca,
                            onRestecgChanged: (newValue) => setState(() => _restecg = newValue),
                            onExangChanged: (newValue) => setState(() => _exang = newValue),
                            onThalChanged: (newValue) => setState(() => _thal = newValue),
                            onCaChanged: (newValue) => setState(() => _ca = newValue),
                          ),
                        ),
                        isActive: _currentStep >= 3,
                        state: StepState.indexed,
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
            onRetry: () => _submitDiagnosis(),
          ),
        ],
      ),
    );
  }

  
  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _trestbpsController = TextEditingController();
    _cholController = TextEditingController();
    _thalchController = TextEditingController();
    _oldpeakController = TextEditingController();
    

    final user = ref.read(userProvider); // recupero l'utente con il provider
    if (user != null) {
      _ageController.text = user.age.toString();
      _sex = user.sex == 1 ? 'Male' : 'Female';
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
     // costruiamo l'input per la diagnosi
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
      // avviamo la diagnosi
      ref.read(diagnosisControllerProvider.notifier).runDiagnosis(input);
  }

  void _resetForm() {
    ref.read(diagnosisControllerProvider.notifier).reset();
    setState(() {
      _currentStep = 0;
    });
  }
}
