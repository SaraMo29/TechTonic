import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_details.controller.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseDetailsController controller =
        Get.find<CourseDetailsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    controller.courseDetails['instructorImage'] ??
                        'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.courseDetails['instructorName'] ??
                          'Instructor Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.courseDetails['instructorTitle'] ??
                          'Instructor',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "About Course",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.aboutContent['description'] ??
                  'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "Course Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.aboutContent['courseDescription'] ??
                  'No course description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              "What You Will Learn",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (controller.aboutContent['whatWillBeTaught'] != null &&
                (controller.aboutContent['whatWillBeTaught'] as List)
                    .isNotEmpty)
              ...List.generate(
                (controller.aboutContent['whatWillBeTaught'] as List).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          (controller.aboutContent['whatWillBeTaught']
                                  as List)[index]
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                "No learning objectives specified for this course",
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            const Text(
              "Target Audience",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (controller.aboutContent['targetAudience'] != null &&
                (controller.aboutContent['targetAudience'] as List).isNotEmpty)
              ...List.generate(
                (controller.aboutContent['targetAudience'] as List).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          (controller.aboutContent['targetAudience']
                                  as List)[index]
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                "No target audience specified for this course",
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            const Text(
              "Requirements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (controller.aboutContent['requirements'] != null &&
                (controller.aboutContent['requirements'] as List).isNotEmpty)
              ...List.generate(
                (controller.aboutContent['requirements'] as List).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          (controller.aboutContent['requirements']
                                  as List)[index]
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                "No requirements specified for this course",
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 24),
            const Text(
              "Tools",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (controller.aboutContent['tools'] != null &&
                (controller.aboutContent['tools'] as List).isNotEmpty)
              ...List.generate(
                (controller.aboutContent['tools'] as List).length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          (controller.aboutContent['tools'] as List)[index]
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (controller.aboutContent['tools'] == null ||
                (controller.aboutContent['tools'] as List).isEmpty)
              const Text(
                "No tools specified for this course",
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      );
    });
  }
}
