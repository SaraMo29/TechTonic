import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/const_promo_card.dart';
import 'package:graduation_project/components/cours_card.dart';
import 'package:graduation_project/components/user_needs.dart';
import 'package:graduation_project/controllers/login_controller.dart';
import 'package:graduation_project/controllers/book_mark_controller.dart';
import 'package:graduation_project/screens/bookMark_screen.dart';
import 'package:graduation_project/screens/instructor_detail_screen.dart';
import 'package:graduation_project/screens/my_courses_screen.dart';
import 'package:graduation_project/screens/notifyScreen.dart';
import 'package:graduation_project/screens/profile_screen.dart';
import 'package:graduation_project/screens/tobMentors_screen.dart';
import 'package:graduation_project/screens/all_course_screen.dart';
import 'package:graduation_project/screens/transaction_screen.dart';
import 'package:graduation_project/screens/compiler_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loginController = Get.find<LoginController>();
  final BookmarkController bookmarkController = Get.find<BookmarkController>();

  List<Map<String, dynamic>> mentorData = [];
  bool isMentorLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMentors();
  }

  Future<void> fetchMentors() async {
    const apiUrl = "https://nafsi.onrender.com/api/v1/users/top-instructors";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2N2Q4ODRkZGVhZjJhNjhjMzQzODIzOGQiLCJpYXQiOjE3NDk5NzEzMzMsImV4cCI6MTc2MDMzOTMzM30.ftf2Wno257oYHfcSkTUllBXATdMNa7m71J-MgiNEqOg',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> apiResults = jsonData['data']['results'];
        final List<Map<String, dynamic>> apiMentors =
            apiResults.cast<Map<String, dynamic>>().map((mentor) {
          final rating = mentor["averageRating"]?.toString() ?? 'N/A';
          final courses = mentor["totalCourses"]?.toString() ?? '0';
          final students = mentor["totalStudents"]?.toString() ?? '0';
          return {
            "id": mentor["_id"]?.toString() ?? "",
            "name": mentor["name"] ?? "No Name",
            "image": mentor["profileImage"] ?? "",
            "job": "Instructor ★ $rating\n$courses Course - $students Student"
          };
        }).toList();
        setState(() {
          mentorData = apiMentors;
          isMentorLoading = false;
        });
      } else {
        setState(() {
          isMentorLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isMentorLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: Obx(() => Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CircleAvatar(
                      backgroundImage: loginController
                              .userProfileImage.value.isNotEmpty
                          ? NetworkImage(loginController.userProfileImage.value)
                          : const AssetImage("assets/images/myphoto.jpg")
                              as ImageProvider,
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Good Morning 👋",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      loginController.userName.value.isNotEmpty
                          ? loginController.userName.value
                          : "User",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ],
            )),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifyscreen()),
                  );
                },
                icon: const Icon(Icons.notifications_none, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarkScreen()),
                  );
                },
                icon: const Icon(Icons.bookmark_outline_outlined,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: Obx(() {
        if (loginController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Search",
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
              const SizedBox(height: 20),
              PromoCarousel(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: UserNeeds(
                  question: "Top Mentors",
                  answer: "See All",
                  questionColor: Colors.black,
                  questionFontSize: 20.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TopMentorsScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 130,
                padding: const EdgeInsets.only(left: 16),
                child: isMentorLoading
                    ? const Center(child: CircularProgressIndicator())
                    : mentorData.isEmpty
                        ? const Center(child: Text("No mentors found"))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: mentorData.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final mentor = mentorData[index];
                              return SizedBox(
                                width: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InstructorDetailScreen(
                                          instructorId: mentor["id"] ?? "",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundImage: mentor["image"] !=
                                                    null &&
                                                mentor["image"].isNotEmpty
                                            ? NetworkImage(mentor["image"])
                                            : const AssetImage(
                                                    "assets/images/myphoto.jpg")
                                                as ImageProvider,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        mentor["name"] ?? "",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: UserNeeds(
                  question: "Most Popular Courses",
                  answer: "See All",
                  questionColor: Colors.black,
                  questionFontSize: 20.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllCourseScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              loginController.courses.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("No courses available"),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(() => Column(
                            children: loginController.courses
                                .asMap()
                                .entries
                                .map((entry) {
                              final int index = entry.key;
                              final course = entry.value;
                              final courseId = course['_id'] ?? '';
                              final isBookmarked = bookmarkController.courses
                                  .any((c) => c['id'] == courseId);

                              return CourseCard(
                                id: courseId,
                                title: course['title'] ?? 'Unknown Course',
                                price: course['price']?['amount'] ?? 'N/A',
                                discountPrice: null,
                                image: course['thumbnail'] ??
                                    'assets/images/default_course.jpg',
                                rating: course['ratingsAverage']?.toString() ??
                                    'N/A',
                                students: null,
                                instructorName: course['instructorName'] ??
                                    'Unknown Instructor',
                                isBookMarked: isBookmarked,
                                onBookmarkToggle: () {
                                  bookmarkController.toggleBookmark(
                                    courseId,
                                    isBookmarked,
                                  );
                                },
                              );
                            }).toList(),
                          )),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: Colors.blue,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.assessment),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCoursesScreen()),
                );
              },
            ),
            label: 'My Course',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.code),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompilerScreen()),
                );
              },
            ),
            label: 'Compiler',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionScreen()),
                );
              },
            ),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
