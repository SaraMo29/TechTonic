import 'package:flutter/material.dart';

class ReviewsContent extends StatelessWidget {
  const ReviewsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // صورة المستخدم
            ),
            title: Text("User ${index + 1}"),
            subtitle: const Text(
                "The course was good, the explanation of the mentor is very clear and easy to understand."),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.thumb_up, size: 20, color: Colors.blue),
                SizedBox(height: 4),
                Text("24"),
              ],
            ),
          ),
        );
      },
    );
  }
}
