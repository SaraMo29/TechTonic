import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final IconData icon;
  final Function(String?) onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
        ),
      ),
      items: items.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val[0].toUpperCase() + val.substring(1)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
