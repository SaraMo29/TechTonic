import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/login_controller.dart';
import '../models/lesson_section.dart';

class CourseSectionsController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();
  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';
  
  var courseProgress = 0.obs;

  var sections = <LessonSection>[].obs;
  var isLoading = false.obs;

  Future<void> fetchSections(String courseId) async {
    try {
      isLoading.value = true;
      final token = _loginController.token.value;

      // Fetch sections
      final sectionsResponse = await http.get(
        Uri.parse('$baseUrl/section/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final sectionsJson = jsonDecode(sectionsResponse.body);
      if (sectionsResponse.statusCode == 200 && sectionsJson['status'] == 'SUCCESS') {
        sections.value = (sectionsJson['data'] as List)
            .map((sectionJson) => LessonSection.fromJson(sectionJson))
            .toList();
      } else {
      }
      
      // Fetch course progress
      await fetchCourseProgress(courseId);
    } catch (e) {
      
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> fetchCourseProgress(String courseId) async {
    try {
      final token = _loginController.token.value;
      
      final progressResponse = await http.get(
        Uri.parse('$baseUrl/progress/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      final progressJson = jsonDecode(progressResponse.body);
      if (progressResponse.statusCode == 200 && progressJson['status'] == 'SUCCESS') {
        courseProgress.value = progressJson['data']['progress'] ?? 0;
      }
    } catch (e) {
      print('Error fetching course progress: $e');
      
    }
  }
}
