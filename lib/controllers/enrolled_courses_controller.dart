import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/login_controller.dart';

class EnrolledCoursesController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();
  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';

  var enrolledCourses = [].obs;
  var isLoading = false.obs;

  Future<void> fetchEnrolledCourses() async {
    try {
      print('Fetching enrolled courses...');
      isLoading.value = true;
      final token = _loginController.token.value;
      
      if (token.isEmpty) {
        print('Token is empty, skipping enrolled courses fetch');
        return;
      }
      
      print('Using token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/course/enrolledCourses'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      print('Enrolled courses API response status: ${response.statusCode}');
      print('Enrolled courses API response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 'SUCCESS') {
        final results = json['data']['results'] as List;
        print('Found ${results.length} enrolled courses');
        enrolledCourses.value = results;
      } else {
        print('Error fetching enrolled courses: ${json['message']}');
        Get.snackbar('Error', json['message'] ?? 'Failed to fetch courses');
      }
    } catch (e) {
      print('Exception during enrolled courses fetch: $e');
      print('Stack trace: ${StackTrace.current}');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      print('Enrolled courses fetch completed, loading state set to false');
      isLoading.value = false;
    }
  }

 
  List<dynamic> get ongoingCourses =>
      enrolledCourses.where((course) => course['progress'] < 1.0).toList();

  List<dynamic> get completedCourses =>
      enrolledCourses.where((course) => course['progress'] >= 1.0).toList();

 
  void updateCourseProgress(String courseId, double newProgress) {
    final index = enrolledCourses.indexWhere((course) => course['_id'] == courseId);
    if (index != -1) {
      enrolledCourses[index]['progress'] = newProgress;
    
      enrolledCourses.refresh();
    }
  }
}
