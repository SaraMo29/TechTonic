import 'package:flutter/material.dart';
import 'courses_tab.dart';
import 'students_tab.dart';
import 'reviews_tab.dart';

class InstructorDetailScreen extends StatelessWidget {
  final String name;
  final String jobTitle;
  final String image;
  final String bio;

  const InstructorDetailScreen({
    super.key,
    required this.name,
    required this.jobTitle,
    required this.image,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Instructor Profile"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              jobTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                InfoColumn(title: "25", subtitle: "Courses"),
                InfoColumn(title: "22,379", subtitle: "Students"),
                InfoColumn(title: "9,287", subtitle: "Reviews"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Message")),
                const SizedBox(width: 10),
                OutlinedButton(onPressed: () {}, child: const Text("Website")),
              ],
            ),
            const SizedBox(height: 20),
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: "Courses"),
                Tab(text: "Students"),
                Tab(text: "Reviews"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  CoursesTab(),
                  StudentsTab(),
                  ReviewsTab(),
                ],
              ),
            )
          ],
        ),
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
