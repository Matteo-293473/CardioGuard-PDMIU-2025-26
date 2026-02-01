// modello per i dati di input necessari alla classificazione 
import 'package:flutter/widgets.dart';

class DiagnosisInput {
  final int age;
  final int trestbps;
  final int chol;
  final int thalach;
  final double oldpeak;
  final String sex;
  final String cp;
  final String fbs;
  final String restecg;
  final String exang;
  final String slope;
  final String thal;
  final int ca;

  DiagnosisInput({
    required this.age,
    required this.trestbps,
    required this.chol,
    required this.thalach,
    required this.oldpeak,
    required this.sex,
    required this.cp,
    required this.fbs,
    required this.restecg,
    required this.exang,
    required this.slope,
    required this.thal,
    required this.ca,
  });

  // metodo factory che permette di creare un DiagnosisInput da controller e valori.
  // Lancio errore se fallisce la validazione (formato errato)
  factory DiagnosisInput.fromControllers({
    required TextEditingController age,
    required TextEditingController trestbps,
    required TextEditingController chol,
    required TextEditingController thalach,
    required TextEditingController oldpeak,
    required String sex,
    required String cp,
    required String fbs,
    required String restecg,
    required String exang,
    required String slope,
    required String thal,
    required int ca,
  }) {
    return DiagnosisInput(
      age: int.tryParse(age.text) ?? 0,
      trestbps: int.tryParse(trestbps.text) ?? 0,
      chol: int.tryParse(chol.text) ?? 0,
      thalach: int.tryParse(thalach.text) ?? 0,
      oldpeak: double.tryParse(oldpeak.text) ?? 0.0,
      sex: sex,
      cp: cp,
      fbs: fbs,
      restecg: restecg,
      exang: exang,
      slope: slope,
      thal: thal,
      ca: ca,
    );
  }
}
