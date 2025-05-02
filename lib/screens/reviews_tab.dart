import 'package:flutter/material.dart';

class ReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _reviewTile(
            'Francene Vandyne',
            'The course is very good. The explanation is very clear and easy to understand.',
            369),
        _reviewTile(
            'Rachel Foose',
            'Awesome! This is what I was looking for. I recommend it to everyone.',
            238),
      ],
    );
  }

  Widget _reviewTile(String name, String review, int likes) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text(review),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Text(likes.toString()),
          ],
        ),
      ),
    );
  }
}
