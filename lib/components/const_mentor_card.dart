import 'package:flutter/material.dart';

class MentorCard extends StatelessWidget {
  final String name;
  final String imagepath;

  const MentorCard({
    Key? key,
    required this.name,
    required this.imagepath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:AssetImage(imagepath) , 
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}