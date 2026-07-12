import 'package:flutter/material.dart';
import 'package:mirath/core/utils/my_colors.dart';

class SettingsTextField extends StatelessWidget {
  const SettingsTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.obscureText = false,
    this.icon,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool? obscureText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      cursorColor: MyColors.primaryColor,
      controller: controller,
      obscureText: obscureText!,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.primaryShade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MyColors.primaryShade800),
        ),
      ),
    );
  }
}
