import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:graduation_project/components/enrolled_course_card.dart';
import 'package:graduation_project/controllers/enrolled_courses_controller.dart';
import 'course_content.dart';

class OngoingCoursesScreen extends StatelessWidget {
  final String searchQuery;
  OngoingCoursesScreen({required this.searchQuery});

  final EnrolledCoursesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredCourses = controller.ongoingCourses.where((course) {
        return course['title']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();

      if (filteredCourses.isEmpty) {
        return const Center(child: Text('No ongoing courses found.'));
      }
      
      return ListView.builder(
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          final course = filteredCourses[index];
          final courseId = course['_id'];  
          
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseContent(
                    title: course['title'],
                    progress: course['progress']?.toDouble() ?? 0.0,
                    id: courseId,  
                  ),
                ),
              );
            },
            child: EnrolledCourseCard(
              title: course['title'],
              instructor: course['instructor'] ?? 'Unknown',
              imageUrl: course['thumbnail'] ?? 'https://via.placeholder.com/150', 
              progress: course['progress']?.toDouble() ?? 0.0,
            ),
          );
        },
      );
    });
  }
}
