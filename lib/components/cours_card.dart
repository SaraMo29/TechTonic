
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String price; 
  final String? discountPrice;
  final String image; 
  final String rating;
  final String? students; 
  final String instructorName; 
  final bool isBookMarked;
  final VoidCallback onBookmarkToggle;

  const CourseCard({
    required this.title,
    required this.price,
    this.discountPrice,
    required this.image,
    required this.rating,
    this.students,
    required this.instructorName,
    required this.isBookMarked,
    required this.onBookmarkToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/default_course.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "By $instructorName",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      discountPrice != null ? "\$$discountPrice" : "\$$price",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    if (discountPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "$rating ⭐${students != null ? ' | $students students' : ''}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onBookmarkToggle,
            icon: Icon(
              isBookMarked ? Icons.bookmark : Icons.bookmark_outline_outlined,
              color: isBookMarked ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
