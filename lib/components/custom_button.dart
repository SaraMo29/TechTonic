import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  const CustomButton({super.key, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Set the button color to blue
        foregroundColor: Colors.white, // Set the text color to white
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text(
        textButton,
      ),
    );
  }
}
