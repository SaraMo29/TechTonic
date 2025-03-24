import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courses = [
    {
      "title": "Java",
      "price": "\$52",
      "oldPrice": "\$88",
      "students": "12,736",
      "rating": "4.8",
      "category": "3D Design",
      "image": "assets/images/course1.jpg",
    },
    {
      "title": "Full-stack Web Development",
      "price": "\$48",
      "students": "11,272",
      "rating": "4.7",
      "category": "Programming",
      "image": "assets/images/course2.jpg",
    },
    {
      "title": "Flutter Mobile Apps",
      "price": "\$44",
      "students": "9,928",
      "rating": "4.8",
      "category": "Programming",
      "image": "assets/images/course3.jpg",
    },
    {
      "title": "WordPress Website Development",
      "price": "\$46",
      "students": "10,298",
      "rating": "4.9",
      "category": "Technology",
      "image": "assets/images/course3.jpg",
    },
  ];

  BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Bookmark"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "3D Design"),
              Tab(text: "Business"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.asset(
                      course["image"],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(course["title"]),
                    subtitle: Text(
                      "${course["price"]} • ${course["students"]} students",
                    ),
                    trailing: Text("${course["rating"]} ⭐"),
                  ),
                );
              },
            ),
            const Center(child: Text("3D Design Courses")),
            const Center(child: Text("Business Courses")),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  final List<Map<String,dynamic>>
  Courses=[{
    "title":"Java",
    "price":"\$52",
    "oldPrice":"\$88",
    "students":"12,736",
    "rating":"4.8",
    "category":"3D Desigen",
    "image": "assets/images/course1.jpg",
  },
  {
    "title":"Full-stack Web Development",
    "price":"\$48",
    "students":"11,272",
    "rating":"4.7",
    "category":"Programming",
    "image": "assets/images/course2.jpg",
  },
  {
    "title":"Flutter Mopile Apps",
    "price":"\$44",
    "students":"9,928",
    "rating":"4.8",
    "category":"Programming",
    "image": "assets/images/course3.jpg",
  },
  {
    "title":"WordPress Website Development",
    "price":"\$46",
    "students":"10,298",
    "rating":"4.9",
    "category":"Technology",
    "image": "assets/images/course3.jpg",
  },
  ];
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Bookmark"),
          bottom:TabBar(tabs: [
            Tap(text:"All"),
            Tap(text:"3D Design"),
            Tap(text:"Business"),

          ],
          ),
        ),
        body: TabBarView(children: [
          ListView.builder(
            itemCount: Courses.length,
            itemBuilder: (context, index){
              final course = Courses[index];
              return Card (
                margin:EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(course["assets/images/course2.jpg"],size: 40),
                  title: Text(course["title"]),
                  subtitle:Text("$
                  {course["price"]}.$
                  {course["students"]}students"),
                  trailing:Text("${
                    course["rating"]
                  }"),
                ),
                );
            },
            ),
            Center(child: Text("3D Design Courses")),
            Center(child: Text("Business Courses")),
        ],
        ),
      ),
    );
  }
}
*/