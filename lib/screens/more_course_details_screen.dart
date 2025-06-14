import 'package:flutter/material.dart';

class MoreCourseDetailsScreen extends StatefulWidget {
  final String title, subTitle, category, language, level;

  const MoreCourseDetailsScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.category,
    required this.language,
    required this.level,
  });

  @override
  State<MoreCourseDetailsScreen> createState() =>
      _MoreCourseDetailsScreenState();
}

class _MoreCourseDetailsScreenState extends State<MoreCourseDetailsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController audienceController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    audienceController.dispose();
    requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("More About Your Course",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Course Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: audienceController,
              decoration: const InputDecoration(
                labelText: 'Target Audience',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: requirementsController,
              decoration: const InputDecoration(
                labelText: 'Requirements',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  debugPrint("Title: ${widget.title}");
                  debugPrint("SubTitle: ${widget.subTitle}");
                  debugPrint("Category: ${widget.category}");
                  debugPrint("Language: ${widget.language}");
                  debugPrint("Level: ${widget.level}");
                  debugPrint("Description: ${descriptionController.text}");
                  debugPrint("Audience: ${audienceController.text}");
                  debugPrint("Requirements: ${requirementsController.text}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Details saved!")),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Save & Finish"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
