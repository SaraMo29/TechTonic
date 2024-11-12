import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final String hintText;
  final TextEditingController controller;
  //final VoidCallback onToggle;
  //final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      //obscureText: passToggle,
      decoration: InputDecoration(
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        labelText: label,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your Email';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.always,
    );
  }
}
