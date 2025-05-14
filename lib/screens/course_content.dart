import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/custom_bottomNavigationbar.dart';
import '../controllers/enrolled_courses_controller.dart';
import 'lessons_tab.dart';
import 'certificate_tab.dart';

class CourseContent extends StatelessWidget {
  final String id; 
  final String title;
  final double progress;

  const CourseContent({
    Key? key,
    required this.id,
    required this.title,
    required this.progress,
  }) : super(key: key);

  bool get isCompleted => progress >= 1.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final enrolledController = Get.find<EnrolledCoursesController>();
        await enrolledController.fetchEnrolledCourses();
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Lessons'),
                Tab(text: 'Certificate'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LessonsTab(isCompleted: isCompleted, courseId: id),
              CertificateTab(isCompleted: isCompleted),
            ],
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
        ),
      ),
    );
  }
}
