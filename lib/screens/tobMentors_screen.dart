import 'package:flutter/material.dart';
import 'package:graduation_project/components/const_mentor_card.dart';

class TopMentorsScreen extends StatefulWidget {
  const TopMentorsScreen({Key? key}) : super(key: key);

  @override
  State<TopMentorsScreen> createState() => _TopMentorsScreenState();
}

class _TopMentorsScreenState extends State<TopMentorsScreen> {
  final List<Map<String, String>> allMentors = [
    {
      "name": "Jacob Kulikowski",
      "image": "assets/images/mentor1.jpg",
      "job": "Full Stack Developer"
    },
    {
      "name": "Claire Winters",
      "image": "assets/images/mentor2.jpg",
      "job": "Data Scientist"
    },
    {
      "name": "Priscilla Nolan",
      "image": "assets/images/mentor5.png",
      "job": "Backend Developer "
    },
    {
      "name": "Wade Warren",
      "image": "assets/images/mentor3.jpg",
      "job": "UX Designer"
    },
    {
      "name": "Kathryn Murphy",
      "image": "assets/images/mentor5.png",
      "job": "Mobile Developer"
    },
     {
      "name": "Mohamed Ahmed",
      "image": "assets/images/mentor1.jpg",
      "job": "Machine Learning Engineer"
    },
    {
      "name": "Johan Winters",
      "image": "assets/images/mentor2.jpg",
      "job": "Cybersecurity Specialist"
    },
    {
      "name": "Selia Nolan",
      "image": "assets/images/mentor5.png",
      "job": "Database Administrator"
    },
    {
      "name": "Sandy Warren",
      "image": "assets/images/mentor3.jpg",
      "job": "Web Developer "
    },
    {
      "name": "Kathryn Murphy",
      "image": "assets/images/mentor5.png",
      "job": "Software Testing "
    },
  ];

  List<Map<String, String>> filteredMentors = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMentors = allMentors; // default list
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMentors = allMentors.where((mentor) {
        return mentor["name"]!.toLowerCase().contains(query);
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
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search mentors...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.blue,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: filteredMentors.isEmpty
            ? const Center(child: Text("No mentors found"))
            : ListView.builder(
                itemCount: filteredMentors.length,
                itemBuilder: (context, index) {
                  final mentor = filteredMentors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: MentorCard(
                      name: mentor["name"]!,
                      imagepath: mentor["image"]!,
                      jobTitle: mentor["job"],
                      showChatIcon: true,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
