import 'package:flutter/material.dart';
import 'package:graduation_project/components/cours_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:graduation_project/controllers/login_controller.dart';

class AllCourseScreen extends StatefulWidget {
  const AllCourseScreen({super.key});

  @override
  State<AllCourseScreen> createState() => _AllCourseScreenState();
}

class _AllCourseScreenState extends State<AllCourseScreen> {
  int selectedCategory = 0;
  final TextEditingController searchController = TextEditingController();

  List<String> categories = ["All"];
  List<Map<String, dynamic>> filteredCourses = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, String> courseIdToCategory = {};

  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      const String categoryUrl =
          'https://nafsi.onrender.com/api/v1/category/getallCategory';
      final categoryResponse = await http.get(
        Uri.parse(categoryUrl),
        headers: {
          'Authorization': 'Bearer ${loginController.token.value}',
          'Content-Type': 'application/json',
        },
      );
      if (categoryResponse.statusCode == 200) {
        final data = json.decode(categoryResponse.body);
        final results = data['data']['results'] as List<dynamic>;

        List<String> fetchedCategories = ["All"];
        Map<String, String> fetchedCourseIdToCategory = {};

        for (var category in results) {
          final String categoryName = category['name'];
          fetchedCategories.add(categoryName);
          for (var courseId in (category['courses'] ?? [])) {
            if (courseId is String) {
              fetchedCourseIdToCategory[courseId] = categoryName;
            }
          }
        }

        setState(() {
          categories = fetchedCategories;
          courseIdToCategory = fetchedCourseIdToCategory;
          isLoading = false;
        });
        _updateFilteredCourses();
      } else {
        print('Status code: ${categoryResponse.statusCode}');
        print('Response body: ${categoryResponse.body}');
        setState(() {
          errorMessage = 'Failed to load categories';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _updateFilteredCourses();
  }

  void _updateFilteredCourses() {
    String query = searchController.text.toLowerCase();

    List<Map<String, dynamic>> allCourses =
        List<Map<String, dynamic>>.from(loginController.courses);

    // Assign category to each course based on courseIdToCategory
    for (var course in allCourses) {
      course["category"] = courseIdToCategory[course["_id"]] ?? "All";
    }

    List<Map<String, dynamic>> tempCourses = selectedCategory == 0
        ? allCourses
        : allCourses
            .where(
                (course) => course["category"] == categories[selectedCategory])
            .toList();

    setState(() {
      filteredCourses = tempCourses.where((course) {
        return (course["title"] ?? course["name"] ?? "")
            .toString()
            .toLowerCase()
            .contains(query);
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
      body: Obx(() {
        if (loginController.isLoading.value || isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (errorMessage.isNotEmpty) {
          return Center(child: Text(errorMessage));
        }
        return Column(
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
                          id: course["_id"] ?? "",
                          title: course["title"] ?? course["name"] ?? "",
                          price: course["price"]["amount"]?.toString() ?? "",
                          discountPrice: course["discountPrice"]?.toString(),
                          image: course["thumbnail"] ?? course["image"] ?? "",
                          rating: course["ratingsAverage"]?.toString() ??
                              course["rating"]?.toString() ??
                              "",
                          students: course["students"]?.toString(),
                          instructorName: course["instructorName"] ??
                              course["instructor"] ??
                              "",
                          isBookMarked: false,
                          onBookmarkToggle: () {},
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
