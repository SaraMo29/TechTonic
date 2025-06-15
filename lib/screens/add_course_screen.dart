import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'more_course_details_screen.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();

  String selectedLanguage = 'English';
  String selectedLevel = 'beginner';
  String selectedCategory = 'Software Development Tools';
  bool isLoading = false;

  final Map<String, String> categoryMap = {
    'Software Development Tools': '682f436141b9d1788bf006f6',
    'Programming Languages': '682f437241b9d1788bf006fa',
    'Network & Security': '682f439b41b9d1788bf006fe',
    'Mobile Development': '682f43a941b9d1788bf00702',
  };

  Future<void> addCourse() async {
    setState(() => isLoading = true);

    const String apiUrl = "https://nafsi.onrender.com/api/v1/course/";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final body = jsonEncode({
      "title": titleController.text,
      "subTitle": subTitleController.text,
      "category": categoryMap[selectedCategory],
      "language": selectedLanguage,
      "level": selectedLevel,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final courseId = responseData['data']['_id'];

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Course created successfully!")),
          );

          // Navigate to MoreCourseDetailsScreen with the course ID
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MoreCourseDetailsScreen(
                title: titleController.text,
                subTitle: subTitleController.text,
                category: selectedCategory,
                language: selectedLanguage,
                level: selectedLevel,
                courseId: courseId,
              ),
            ),
          );

          if (result == true && mounted) {
            Navigator.pop(context, true);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add course: ${response.body}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Course")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Course Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subTitleController,
              decoration: const InputDecoration(
                labelText: 'Subtitle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categoryMap.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedLanguage = val);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Level',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                    value: 'intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedLevel = val);
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: addCourse,
                      icon: const Icon(Icons.save),
                      label: const Text("Create Course"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
