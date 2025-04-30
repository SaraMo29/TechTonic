import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/components/const_mentor_card.dart';
import 'package:graduation_project/components/const_promo_card.dart';
import 'package:graduation_project/components/cours_card.dart';
import 'package:graduation_project/components/user_needs.dart';
import 'package:graduation_project/controllers/login_controller.dart';
import 'package:graduation_project/screens/bookMark_screen.dart';
import 'package:graduation_project/screens/notifyScreen.dart';
import 'package:graduation_project/screens/profile_screen.dart';
import 'package:graduation_project/screens/tobMentors_screen.dart';
import 'package:graduation_project/screens/all_course_screen.dart'; // تعديل هنا ليطابق الاسم الجديد

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController loginController = Get.find();
  late List<bool> isBookMarked;

  final List<Map<String, String>> mentorData = [
    {"name": "Jacob", "image": "assets/images/mentor1.jpg"},
    {"name": "Claire", "image": "assets/images/mentor2.jpg"},
    {"name": "Priscilla", "image": "assets/images/mentor5.png"},
    {"name": "Wade", "image": "assets/images/mentor3.jpg"},
    {"name": "Kathryn", "image": "assets/images/mentor5.png"},
  ];

  @override
  void initState() {
    super.initState();
    isBookMarked = List<bool>.filled(loginController.courses.length, false);
    ever(loginController.courses, (_) {
      setState(() {
        isBookMarked = List<bool>.filled(loginController.courses.length, false);
      });
    });
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
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/myphoto.jpg"),
              radius: 25,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning 👋",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Sara Mohamed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: mentorData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 80,
                      child: MentorCard(
                        name: mentorData[index]["name"]!,
                        imagepath: mentorData[index]["image"]!,
                        jobTitle: null,
                        showChatIcon: false,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: UserNeeds(
                  question: "Most Popular Courses", // الاسم الذي سيظهر للمستخدم
                  answer: "See All",
                  questionColor: Colors.black,
                  questionFontSize: 20.0,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllCourseScreen()), // تعديل هنا
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
                      child: Column(
                        children: loginController.courses
                            .asMap()
                            .entries
                            .map((entry) {
                          final int index = entry.key;
                          final course = entry.value;
                          return CourseCard(
                            id: course['_id'] ??
                                '', // Pass the course ID from API
                            title: course['title'] ?? 'Unknown Course',
                            price: course['price']?['amount'] ?? 'N/A',
                            discountPrice: null,
                            image: course['thumbnail'] ??
                                'assets/images/default_course.jpg',
                            rating:
                                course['ratingsAverage']?.toString() ?? 'N/A',
                            students: null,
                            instructorName: course['instructorName'] ??
                                'Unknown Instructor',
                            isBookMarked: isBookMarked[index],
                            onBookmarkToggle: () {
                              setState(() {
                                isBookMarked[index] = !isBookMarked[index];
                              });
                            },
                          );
                        }).toList(),
                      ),
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
                icon: const Icon(Icons.assessment), onPressed: () {}),
            label: 'My Course',
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
          BottomNavigationBarItem(
            icon: IconButton(
                icon: const Icon(Icons.shopping_cart), onPressed: () {}),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                loginController.logout();
              },
            ),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
