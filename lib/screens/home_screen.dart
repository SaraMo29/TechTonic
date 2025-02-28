import 'package:flutter/material.dart';
import 'package:graduation_project/components/const_mentor_card.dart';
import 'package:graduation_project/components/const_promo_card.dart';
import 'package:graduation_project/components/cours_card.dart';
import 'package:graduation_project/components/filters_listView.dart';
import 'package:graduation_project/components/user_needs.dart';
import 'package:graduation_project/screens/notifyScreen.dart';
import 'package:graduation_project/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBookMarked = false;

  final List<Map<String, String>> mentorData = [
    {"name": "Jacob", "image": "assets/images/mentor1.jpg"},
    {"name": "Claire", "image": "assets/images/mentor2.jpg"},
    {"name": "Priscilla", "image": "assets/images/mentor5.png"},
    {"name": "Wade", "image": "assets/images/mentor3.jpg"},
    {"name": "Kathryn", "image": "assets/images/mentor5.png"},
  ];

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
                    MaterialPageRoute(
                      builder: (context) =>  Notifyscreen(),
                    ),
                  );
                  },
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.black)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_outline_outlined,
                      color: Colors.black)),
            ],
          ),
          const SizedBox(width: 30)
        ],
      ),
      body: SingleChildScrollView(
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
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
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
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: UserNeeds(
                question: "Top Mentors",
                answer: "See All",
                questionColor: Colors.black,
                questionFontSize: 20.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mentorData.length,
                itemBuilder: (context, index) {
                  return MentorCard(
                    name: mentorData[index]["name"]!,
                    imagepath: mentorData[index]["image"]!,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: UserNeeds(
                question: "Most Popular Courses",
                answer: "See All",
                questionColor: Colors.black,
                questionFontSize: 20.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FiltersListview(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CourseCard(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: Colors.blue,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.assessment),
                onPressed: () {},
              ),
              label: 'My Course'),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
              ),
              label: 'Profile'),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              label: 'Transaction'),
          BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              label: 'Setting'),
        ],
      ),
    );
  }
}
