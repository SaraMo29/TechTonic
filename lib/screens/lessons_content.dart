import 'package:flutter/material.dart';

class LessonsContent extends StatelessWidget {
  const LessonsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text("${index + 1}"),
          ),
          title: Text("Lesson Title ${index + 1}"),
          subtitle: Text("${15 + index * 5} mins"),
          trailing: const Icon(Icons.lock_outline),
        );
      },
    );
  }
}
