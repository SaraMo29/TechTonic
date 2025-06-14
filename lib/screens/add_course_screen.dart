import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'more_course_details_screen.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();

  String selectedLanguage = 'English';
  String selectedLevel = 'beginner';
  bool isLoading = false;

  Future<void> addCourse() async {
    setState(() => isLoading = true);

    const String apiUrl = "https://yourapi.com/v1/course/";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "title": titleController.text,
        "subTitle": subTitleController.text,
        "category": categoryIdController.text,
        "language": selectedLanguage,
        "level": selectedLevel,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course added successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add course: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Course")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subTitleController,
              decoration: const InputDecoration(labelText: 'Subtitle'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryIdController,
              decoration: const InputDecoration(labelText: 'Category ID'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedLanguage = val);
              },
              decoration: const InputDecoration(labelText: 'Language'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                    value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedLevel = val);
              },
              decoration: const InputDecoration(labelText: 'Level'),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: addCourse,
                        icon: const Icon(Icons.save),
                        label: const Text("Add Course"),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MoreCourseDetailsScreen(
                                title: titleController.text,
                                subTitle: subTitleController.text,
                                category: categoryIdController.text,
                                language: selectedLanguage,
                                level: selectedLevel,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Continue to Details"),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
