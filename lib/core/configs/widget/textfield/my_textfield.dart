import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
