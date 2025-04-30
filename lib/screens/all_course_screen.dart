import 'package:flutter/material.dart';
import 'package:graduation_project/components/cours_card.dart';

class AllCourseScreen extends StatefulWidget {
  const AllCourseScreen({super.key});

  @override
  State<AllCourseScreen> createState() => _AllCourseScreenState();
}

class _AllCourseScreenState extends State<AllCourseScreen> {
  int selectedCategory = 0;
  final TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "3D Design",
    "Business",
    "UI/UX",
    "Programming",
  ];

  final List<Map<String, dynamic>> allCourses = [
    {
      "id": "course1", // Added course ID
      "title": "3D Design Illustration",
      "price": "80",
      "discountPrice": "48",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Blue_3D_design.jpg/640px-Blue_3D_design.jpg",
      "rating": "4.8",
      "students": "8,289",
      "instructor": "James Art",
      "category": "3D Design"
    },
    {
      "id": "course2", // Added course ID
      "title": "Digital Entrepreneurship",
      "price": "39",
      "discountPrice": null,
      "image":
          "https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg",
      "rating": "4.9",
      "students": "6,182",
      "instructor": "Sarah Lee",
      "category": "Business"
    },
    {
      "id": "course3", // Added course ID
      "title": "Learn UX User Persona",
      "price": "75",
      "discountPrice": "42",
      "image":
          "https://cdn.pixabay.com/photo/2017/01/06/19/15/user-experience-1957393_960_720.jpg",
      "rating": "4.7",
      "students": "7,938",
      "instructor": "Michael UX",
      "category": "UI/UX"
    },
    {
      "id": "course4", // Added course ID
      "title": "Flutter Mobile Apps",
      "price": "72",
      "discountPrice": "44",
      "image":
          "https://cdn.pixabay.com/photo/2015/01/21/14/14/iphone-606761_960_720.jpg",
      "rating": "4.8",
      "students": "9,928",
      "instructor": "Ahmed Dev",
      "category": "Programming"
    },
  ];

  List<Map<String, dynamic>> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _updateFilteredCourses();
  }

  void _onSearchChanged() {
    _updateFilteredCourses();
  }

  void _updateFilteredCourses() {
    String query = searchController.text.toLowerCase();

    List<Map<String, dynamic>> tempCourses = selectedCategory == 0
        ? allCourses
        : allCourses
            .where(
                (course) => course["category"] == categories[selectedCategory])
            .toList();

    setState(() {
      filteredCourses = tempCourses.where((course) {
        return (course["title"] ?? "").toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Popular Courses"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search courses...",
                hintStyle: const TextStyle(
                    color: Color.fromARGB(83, 0, 0, 0), fontSize: 16),
                prefixIcon:
                    const Icon(Icons.search, size: 25, color: Colors.black),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = selectedCategory == index;
                return ChoiceChip(
                  label: Text(categories[index]),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = index;
                    });
                    _updateFilteredCourses();
                  },
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text("No courses found"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return CourseCard(
                        id: course["id"], // Pass the course ID
                        title: course["title"],
                        price: course["price"],
                        discountPrice: course["discountPrice"],
                        image: course["image"],
                        rating: course["rating"],
                        students: course["students"],
                        instructorName: course["instructor"],
                        isBookMarked: false,
                        onBookmarkToggle: () {
                          // Bookmark functionality هنا لو محتاج تضيفه بعدين
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
