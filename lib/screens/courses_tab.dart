import 'package:flutter/material.dart';

class CoursesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _courseCard('Learn UX User Persona', '\$42', '7,098 students'),
        _courseCard('3D Design Illustration', '\$42', '6,987 students'),
      ],
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
