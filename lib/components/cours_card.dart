import 'package:flutter/material.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({Key? key}) : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  final List<Map<String, String>> coursesData = [
    {
      "title": "Java Script",
      "price": "95",
      "discountPrice": "30",
      "image": "assets/images/course1.jpg",
      "rating": "4.8",
      "students": "8,289"
    },
    {
      "title": "Dart",
      "price": "80",
      "discountPrice": "40",
      "image": "assets/images/course2.jpg",
      "rating": "4.9",
      "students": "6,182"
    },
    {
      "title": "Learn UX/UX User Persona",
      "price": "75",
      "discountPrice": "20",
      "image": "assets/images/course3.jpg",
      "rating": "4.7",
      "students": "7,938"
    },
  ];

  late List<bool> isBookMarked;

  @override
  void initState() {
    super.initState();
    isBookMarked = List<bool>.filled(coursesData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: coursesData.asMap().entries.map((entry) {
        final int index = entry.key;
        final course = entry.value;

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
                child: Image.asset(
                  course['image']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "\$${course['discountPrice']!}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "\$${course['price']!}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${course['rating']} ⭐ | ${course['students']} students",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isBookMarked[index] = !isBookMarked[index];
                  });
                },
                icon: Icon(
                  isBookMarked[index]
                      ? Icons.bookmark
                      : Icons.bookmark_outline_outlined,
                  color: isBookMarked[index] ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
