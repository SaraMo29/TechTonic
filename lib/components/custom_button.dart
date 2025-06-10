import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPress;
  const CustomButton({super.key, required this.textButton, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(
        textButton,
      ),
    );
  }
}
