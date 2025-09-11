import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      cursorColor: Colors.blue,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        // Viền khi không focus
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),

        // Viền khi focus
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2.5),
        ),

        // Viền khi có lỗi
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),

        // Viền khi focus và có lỗi
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2.5),
        ),

        // Label styling
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        floatingLabelStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),

        // Icon styling
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),

        // Màu nền nhẹ khi focus
        fillColor: const Color.fromARGB(255, 132, 139, 144).withValues(alpha: 0.05),
        filled: true,
      ),
    );
  }
}
