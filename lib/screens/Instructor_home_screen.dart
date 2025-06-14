import 'package:flutter/material.dart';
import 'package:graduation_project/controllers/login_controller.dart';
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
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
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
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text("Add Course"),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
