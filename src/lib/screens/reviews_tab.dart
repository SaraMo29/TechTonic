import 'package:flutter/material.dart';

class ReviewsTab extends StatelessWidget {
  final List<dynamic> reviews;

  const ReviewsTab({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Center(child: Text('No reviews available.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return _reviewTile(
          review['name'] ?? 'Anonymous',
          review['comment'] ?? '',
          review['likes'] ?? 0,
        );
      },
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
            
            SizedBox(width: 4),
            
          ],
        ),
      ),
    );
  }
}
