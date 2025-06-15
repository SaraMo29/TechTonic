import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/instructor_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:graduation_project/components/const_mentor_card.dart';

class TopMentorsScreen extends StatefulWidget {
  const TopMentorsScreen({Key? key}) : super(key: key);

  @override
  State<TopMentorsScreen> createState() => _TopMentorsScreenState();
}

class _TopMentorsScreenState extends State<TopMentorsScreen> {
  List<Map<String, dynamic>> allMentors = [];
  List<Map<String, dynamic>> filteredMentors = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMentors();
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

  Future<void> fetchMentors() async {
    const apiUrl = "https://nafsi.onrender.com/api/v1/users/top-instructors";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2N2Q4ODRkZGVhZjJhNjhjMzQzODIzOGQiLCJpYXQiOjE3NDU2MDkyMTEsImV4cCI6MTc1NTk3NzIxMX0.UDECe1ZqE8YjAKN725hLOIHDcnioHPRxbzuc1d95fX4',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> apiResults = jsonData['data']['results'];

        final List<Map<String, dynamic>> apiMentors = apiResults
            .cast<Map<String, dynamic>>()
            .map((mentor) {
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
          allMentors = apiMentors;
          filteredMentors = apiMentors;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load mentors: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching mentors: $e");
      setState(() {
        isLoading = false;
      });
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: filteredMentors.isEmpty
                  ? const Center(child: Text("No mentors found"))
                  : ListView.builder(
                      itemCount: filteredMentors.length,
                      itemBuilder: (context, index) {
                        final mentor = filteredMentors[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InstructorDetailScreen(
                                  instructorId: mentor["id"] ?? "", 
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: MentorCard(
                              name: mentor["name"],
                              imagepath: mentor["image"],
                              jobTitle: mentor["job"],
                              
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
