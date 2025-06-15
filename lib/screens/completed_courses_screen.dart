import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:graduation_project/components/enrolled_course_card.dart';
import 'package:graduation_project/controllers/enrolled_courses_controller.dart';
import 'course_content.dart';

class CompletedCoursesScreen extends StatelessWidget {
  final String searchQuery;
  CompletedCoursesScreen({required this.searchQuery});

  final EnrolledCoursesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final completedCourses = controller.completedCourses.where((course) {
        return course['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();

      if (completedCourses.isEmpty) {
        return const Center(child: Text('No completed courses found.'));
      }

      return ListView.builder(
        itemCount: completedCourses.length,
        itemBuilder: (context, index) {
          final course = completedCourses[index];
          final courseId = course['_id'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseContent(
                    title: course['title'],
                    progress: course['progress']?.toDouble() ?? 1.0,
                    id: courseId,
                  ),
                ),
              );
            },
            child: EnrolledCourseCard(
              title: course['title'],
              instructor: course['instructor'] ?? 'Unknown',
              imageUrl: course['thumbnail'] ?? 'https://via.placeholder.com/150',
              progress: course['progress']?.toDouble() ?? 1.0,
            ),
          );
        },
      );
    });
  }
}
