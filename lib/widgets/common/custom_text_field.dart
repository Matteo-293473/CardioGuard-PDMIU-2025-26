// widget personalizzato per campi di testo con validazione integrata
// logica + stile
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final num? min;
  final num? max;
  final String? suffixText;
  final bool isInteger;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool onlyText;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.min,
    this.max,
    this.maxLength,
    this.suffixText,
    this.isInteger = false,
    this.onlyText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: icon != null ? Icon(icon, color: Theme.of(context).colorScheme.primary) : null,
        helperText: (min != null && max != null) ? 'Range: $min - $max' : null,
      ),
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: keyboardType ?? (onlyText ? TextInputType.name : TextInputType.numberWithOptions(decimal: !isInteger)),
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      // per la validazione possiamo passarne una oppure viene gestita qui
      validator: validator ?? (v) {
        if (v == null || v.trim().isEmpty) return 'Campo obbligatorio';
        if (onlyText) {
          // caso solo testo
          if (maxLength != null && v.trim().length > maxLength!) return 'Massimo $maxLength caratteri';
          if (RegExp(r'[0-9]').hasMatch(v)) return 'Numeri non permessi' ;
        } else {
          // caso intero
          if (isInteger) {
            final value = int.tryParse(v);
            if (value == null) return 'Inserire un numero intero';
            if (min != null && value < min!) return 'Minimo: $min';
            if (max != null && value > max!) return 'Massimo: $max';
          } else {
            // parsing con virgola o punto
            final value = double.tryParse(v.replaceAll(',', '.'));
            if (value == null) return 'Inserire un numero valido';
            if (min != null && value < min!) return 'Minimo: $min';
            if (max != null && value > max!) return 'Massimo: $max';
          }
        }
        return null;
      },
    );
  }
}

