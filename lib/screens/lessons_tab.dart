import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controllers/course_sections_controller.dart';
import 'package:graduation_project/controllers/enrolled_courses_controller.dart';
import 'package:graduation_project/controllers/login_controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'video_player_screen.dart';

class LessonsTab extends StatelessWidget {
  final bool isCompleted;
  final String courseId;

  LessonsTab({Key? key, required this.isCompleted, required this.courseId}) : super(key: key);

  final CourseSectionsController controller = Get.put(CourseSectionsController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.fetchSections(courseId),
      builder: (context, snapshot) {
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.sections.isEmpty) {
            return const Center(child: Text('No lessons available.'));
          }

          // Progress value is still calculated but UI indicator removed
          final progressValue = controller.courseProgress.value / 100.0;

          return Column(
            children: [
              Expanded(child: buildLessonsList(context)),
            ],
          );
        });
      },
    );
  }

  Widget buildLessonsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: controller.sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = controller.sections[sectionIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${section.durationMinutes} mins',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            ...section.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lesson = entry.value;
              final unlocked = isCompleted || lesson.isFree;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    lesson.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${lesson.durationMinutes} mins',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Icon(
                    unlocked ? Icons.play_circle_fill : Icons.lock_outline,
                    color: unlocked ? Colors.blue : Colors.grey,
                    size: 28,
                  ),
                  onTap: unlocked
                      ? () async {
                          final LoginController loginController = Get.find<LoginController>();
                          final token = loginController.token.value;

                          try {
                            final response = await http.post(
                              Uri.parse('https://nafsi.onrender.com/api/v1/progress/'),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                'courseId': courseId,
                                'moduleId': lesson.id,
                              }),
                            );

                            if (response.statusCode == 200 || response.statusCode == 201) {
                              final responseData = jsonDecode(response.body);
                              if (responseData['status'] == 'SUCCESS') {
                                final newProgress = responseData['data']['progress']?.toDouble();

                                if (newProgress != null) {
                                  controller.courseProgress.value = newProgress;

                                  final enrolledController = Get.find<EnrolledCoursesController>();
                                  enrolledController.updateCourseProgress(courseId, newProgress / 100.0);
                                }
                              } else {
                                Get.snackbar("Error", "Failed to update progress");
                              }
                            } else {
                              Get.snackbar("Error", "API error: ${response.statusCode}");
                            }
                          } catch (e) {
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: lesson.fileUrl,
                                title: lesson.name,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
