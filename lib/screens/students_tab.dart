import 'package:flutter/material.dart';

class StudentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _studentTile('Benny Spanbour', 'Student'),
        _studentTile('Freida Varnes', 'Junior Designer'),
        _studentTile('Francene Vandyne', 'Freelancer'),
        _studentTile('Tanner Stafford', 'Student'),
      ],
    );
  }

  Widget _studentTile(String name, String role) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text(role),
    );
  }
}
