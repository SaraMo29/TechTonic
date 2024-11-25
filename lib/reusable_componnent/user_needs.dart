import 'package:flutter/material.dart';

class UserNeeds extends StatelessWidget {
  const UserNeeds({super.key, required this.question, required this.answer});
  final String question;
  final String answer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            answer,
            style: const TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }
}
