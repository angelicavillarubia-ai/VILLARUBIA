import 'package:flutter/material.dart';

/// Shared text input. Reused in Login and ReportFormScreen.
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final int maxLines;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
