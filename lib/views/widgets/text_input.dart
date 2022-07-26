import 'package:flutter/material.dart';
import 'package:tiktok/constants/app_sizes.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.onChanged,
    this.suffix,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(
          fontSize: FontSize.s18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
