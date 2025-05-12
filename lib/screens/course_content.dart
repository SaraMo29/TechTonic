import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                if (isCompleted) {
                  print('Start Course Again');
                } else {
                  print('Continue Course');
                }
              },
              child: Text(
                isCompleted ? 'Start Course Again' : 'Continue Course',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
