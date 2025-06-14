import 'package:flutter/material.dart';
import 'courses_tab.dart';
import 'reviews_tab.dart';
import 'package:get/get.dart';
import '../controllers/instructor_detail_controller.dart';

class InstructorDetailScreen extends StatelessWidget {
  final String instructorId;

  const InstructorDetailScreen({
    super.key,
    required this.instructorId,
  });

  @override
  Widget build(BuildContext context) {
    final InstructorDetailController controller = Get.put(InstructorDetailController());

    
    controller.fetchInstructorProfile(instructorId);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Instructor Profile"),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.instructorData.isEmpty) {
            return Center(child: Text('No data found.'));
          }
          final data = controller.instructorData;
          return Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(data['profileImage'] ?? ''),
              ),
              const SizedBox(height: 10),
              Text(
                data['name'] ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoColumn(title: "${data['totalCourses'] ?? 0}", subtitle: "Courses"),
                  InfoColumn(title: "${data['totalStudents'] ?? 0}", subtitle: "Students"),
                  InfoColumn(title: "${data['totalReviews'] ?? 0}", subtitle: "Reviews"),
                ],
              ),
              const SizedBox(height: 20),
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: "Courses"),
                  Tab(text: "Reviews"),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    CoursesTab(courses: data['courses'] ?? []),
                    ReviewsTab(reviews: data['reviews'] ?? []),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
    }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String subtitle;

  const InfoColumn({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
