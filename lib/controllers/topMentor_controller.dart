// controller/topMentor_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TopMentorsController extends GetxController {
  var allMentors = <Map<String, dynamic>>[].obs;
  var filteredMentors = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  Future<void> fetchTopMentors() async {
    const apiUrl = 'https://nafsi.onrender.com/api/v1/users/top-instructors';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> apiResults = jsonData['data']['results'];

        final mentors = apiResults.map((mentor) {
          final rating = mentor['averageRating']?.toString() ?? 'N/A';
          final courses = mentor['totalCourses']?.toString() ?? '0';
          final students = mentor['totalStudents']?.toString() ?? '0';

          return {
            "name": mentor['name'] ?? 'No Name',
            "image": mentor['profileImage'] ?? '',
            "job": "Instructor ★ $rating\n$courses Course - $students Student"
          };
        }).toList();

        allMentors.assignAll(mentors);
        filteredMentors.assignAll(mentors);
      } else {
        Get.snackbar("Error", "Failed to fetch mentors: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch mentors");
    } finally {
      isLoading.value = false;
    }
  }

  void searchMentors(String query) {
    final lowerQuery = query.toLowerCase();
    filteredMentors.assignAll(
      allMentors.where((mentor) => mentor['name'].toLowerCase().contains(lowerQuery)).toList(),
    );
  }
}
