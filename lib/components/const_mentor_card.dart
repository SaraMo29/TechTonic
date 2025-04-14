// const_mentor_card.dart
import 'package:flutter/material.dart';

class MentorCard extends StatelessWidget {
  final String name;
  final String imagepath;
  final String? jobTitle;
  final bool showChatIcon;

  const MentorCard({
    super.key,
    required this.name,
    required this.imagepath,
    this.jobTitle,
    this.showChatIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    // لو في وظيفه، يبقى شكل صف، غير كده شكل عمودي
    if (jobTitle != null) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagepath),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(jobTitle!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            if (showChatIcon)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat, color: Colors.blue),
              ),
          ],
        ),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagepath),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
}
