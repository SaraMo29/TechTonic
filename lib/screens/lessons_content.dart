import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_details.controller.dart';
import 'video_player_screen.dart';

class LessonsContent extends StatelessWidget {
  const LessonsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseDetailsController controller =
        Get.find<CourseDetailsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.lessons.isEmpty) {
        return const Center(
            child: Text("No lessons available for this course"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.lessons.length,
        itemBuilder: (context, index) {
          final lesson = controller.lessons[index];
          final lessonId = lesson['id'] ?? '';

          // Find modules for this lesson
          final lessonModules = controller.modules
              .where((module) => module['lessonId'] == lessonId)
              .toList();

          return ExpansionTile(
            leading: CircleAvatar(
              child: Text("${index + 1}"),
            ),
            title: Text(lesson['title'] ?? "Untitled Lesson"),
            subtitle: Text("${lesson['duration'] ?? '0'} mins"),
            trailing: Icon(
              lesson['isLocked'] == true
                  ? Icons.lock_outline
                  : Icons.keyboard_arrow_down,
              color: lesson['isLocked'] == true ? Colors.grey : Colors.blue,
            ),
            children: [
              if (lessonModules.isNotEmpty)
                ...lessonModules.map((module) {
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.only(left: 32.0, right: 16.0),
                    leading: const Icon(Icons.play_circle_outline,
                        color: Colors.blue),
                    title: Text(
                      module['title'] ?? 'Untitled Video',
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      '${module['duration'] ?? "0"} mins',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: lesson['isLocked'] == true
                        ? const Icon(Icons.lock_outline,
                            size: 20, color: Colors.grey)
                        : const Icon(Icons.play_arrow,
                            size: 20, color: Colors.green),
                    onTap: () {
                      if (lesson['isLocked'] != true) {
                        // Navigate to video player screen
                        final videoUrl = module['videoUrl'];
                        if (videoUrl != null && videoUrl.isNotEmpty) {
                          Get.to(() => VideoPlayerScreen(
                                videoUrl: videoUrl,
                                title: module['title'] ?? 'Untitled Video',
                              ));
                        } else {
                          Get.snackbar(
                            'Video Unavailable',
                            'The video for this module is not available.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      } else {
                        Get.snackbar(
                          'Locked Content',
                          'This content is locked. Please purchase the course to access it.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  );
                }).toList()
              else
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text('No modules available for this lesson'),
                ),
            ],
          );
        },
      );
    });
  }
}
