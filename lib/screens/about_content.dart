import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150', // هنا تحطي صورة المدرب
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Jonathan Williams",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Senior UI/UX Designer at Google",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "About Course",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Learn UI/UX design from scratch. This course covers the basic principles of user experience design and user interface best practices. Learn how to use Figma to create beautiful designs.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            "Tools",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/3/33/Figma-logo.svg',
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              const Text(
                "Figma",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
