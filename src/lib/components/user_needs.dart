import 'package:flutter/material.dart';

class UserNeeds extends StatelessWidget {
  const UserNeeds({
    super.key,
    required this.question,
    required this.answer,
    this.questionColor = Colors.grey,
    this.answerColor = Colors.blue,
    this.questionFontSize = 15.0,
    this.answerFontSize = 14.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  });

  final String question;
  final String answer;
  final Color questionColor;
  final Color answerColor;
  final double questionFontSize;
  final double answerFontSize;
  final MainAxisAlignment mainAxisAlignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          question,
          style: TextStyle(
            color: questionColor,
            fontSize: questionFontSize,
          ),
        ),
        TextButton(
          onPressed: onTap, 
          child: Text(
            answer,
            style: TextStyle(
              color: answerColor,
              fontSize: answerFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
