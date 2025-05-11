import 'package:flutter/material.dart';

class CoursesTab extends StatelessWidget {
  final List<dynamic> courses;

  const CoursesTab({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Center(child: Text('No courses available.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _courseCard(
          course['title'] ?? 'No Title',
          course['price']['amount'] != null ? '\$${course['price']['amount']}' : '',
          '${course['students'] ?? 0} students',
        );
      },
    );
  }

  Widget _courseCard(String title, String price, String students) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.school),
        title: Text(title),
        subtitle: Text('$price - $students'),
      ),
    );
  }
}
