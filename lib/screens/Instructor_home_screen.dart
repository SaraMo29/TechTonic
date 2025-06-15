import 'package:flutter/material.dart';
import 'package:graduation_project/controllers/login_controller.dart';
import 'package:graduation_project/screens/add_course_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstructorCourse {
  final String id;
  final String title;
  final String thumbnail;
  final String instructorName;
  final double ratingsAverage;
  final int profits;
  final int enrolledStudentsCount;

  InstructorCourse({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.instructorName,
    required this.ratingsAverage,
    required this.profits,
    required this.enrolledStudentsCount,
  });

  factory InstructorCourse.fromJson(Map<String, dynamic> json) {
    return InstructorCourse(
      id: json['_id'],
      title: json['title'],
      thumbnail: json['thumbnail'].toString().replaceAll('`', '').trim(),
      instructorName: json['instructorName'] ?? '',
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
      profits: json['profits'] ?? 0,
      enrolledStudentsCount: json['enrolledStudentsCount'] ?? 0,
    );
  }
}

class InstructorHomeScreen extends StatefulWidget {
  const InstructorHomeScreen({Key? key}) : super(key: key);

  @override
  State<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  List<InstructorCourse> courses = [];
  bool isLoading = true;
  String errorMessage = '';
  String instructorName = '';
  String instructorPhoto = '';
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    fetchInstructorCourses();
  }

  Future<void> fetchInstructorCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Retrieve token from storage or pass it from login
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        setState(() {
          errorMessage = 'No token found. Please login again.';
          isLoading = false;
        });
        return;
      }
      const String url =
          'https://nafsi.onrender.com/api/v1/course/getInstructorCourse';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List<dynamic>;
        setState(() {
          courses = results.map((e) => InstructorCourse.fromJson(e)).toList();
          if (courses.isNotEmpty) {
            instructorName = courses[0].instructorName;
            instructorPhoto =
                'assets/images/myphoto.jpg'; // Replace with actual photo if available
          }
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load courses';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No token found. Please login again.')),
        );
        return;
      }

      final response = await http.delete(
        Uri.parse('https://nafsi.onrender.com/api/v1/course/$courseId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
        // Refresh the course list
        fetchInstructorCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete course: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundImage:
                    loginController.userProfileImage.value.isNotEmpty
                        ? NetworkImage(loginController.userProfileImage.value)
                        : const AssetImage("assets/images/myphoto.jpg")
                            as ImageProvider,
                radius: 25,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome Back 👋",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(
                  instructorName.isNotEmpty
                      ? instructorName
                      : "Instructor Name",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            course.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Enrolled: ${course.enrolledStudentsCount} | Rating: ${course.ratingsAverage}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Course'),
                                  content: const Text(
                                      'Are you sure you want to delete this course? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteCourse(course.id);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text("Add Course"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCourseScreen()),
          );
          if (result == true) {
            fetchInstructorCourses(); // Refresh the course list
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Colors.blue, size: 30),
            const SizedBox(width: 8),
            const Text(
              'Home',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
