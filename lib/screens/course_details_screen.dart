import 'package:flutter/material.dart';
import 'about_content.dart';
import 'lessons_content.dart';
import 'reviews_content.dart';

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final String price;
  final String? discountPrice;
  final String image;
  final String rating;
  final String instructorName;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.price,
    this.discountPrice,
    required this.image,
    required this.rating,
    required this.instructorName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Image.network(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("\$$price",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.blue)),
                        if (discountPrice != null) ...[
                          const SizedBox(width: 10),
                          Text("\$$discountPrice",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough)),
                        ],
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Instructor: $instructorName",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "About"),
                  Tab(text: "Lessons"),
                  Tab(text: "Reviews"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    AboutContent(),
                    LessonsContent(),
                    ReviewsContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
