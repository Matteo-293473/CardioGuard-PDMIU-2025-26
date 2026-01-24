import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final double? min;
  final double? max;
  final String? suffixText;
  final bool isInteger;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool onlyText;

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
        helperText: (min != null && max != null) ? 'Range: ${min!.toInt()} - ${max!.toInt()}' : null,
      ),
      keyboardType: keyboardType ?? (onlyText ? TextInputType.name : TextInputType.numberWithOptions(decimal: !isInteger)),
      validator: validator ?? (v) {
        if (v == null || v.trim().isEmpty) return 'Campo obbligatorio';
        if (onlyText) {
          // caso solo testo
          if (maxLength != null && v.trim().length > maxLength!) return 'Massimo $maxLength caratteri';
          if (RegExp(r'[0-9]').hasMatch(v)) return 'Numeri non permessi';
        } else {
          // caso intero
          if (isInteger) {
            final value = int.tryParse(v);
            if (value == null) return 'Inserire un numero intero';
            if (min != null && value < min!) return 'Minimo: ${min!.toInt()}';
            if (max != null && value > max!) return 'Massimo: ${max!.toInt()}';
          } else {
            final value = double.tryParse(v);
            if (value == null) return 'Inserire un numero valido';
            if (min != null && value < min!) return 'Minimo: ${min!.toInt()}';
            if (max != null && value > max!) return 'Massimo: ${max!.toInt()}';
          }
        }
        return null;
      },
    );
  }
}

