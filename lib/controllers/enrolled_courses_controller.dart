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
      isLoading.value = true;
      final token = _loginController.token.value;

      final response = await http.get(
        Uri.parse('$baseUrl/course/enrolledCourses'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 'SUCCESS') {
        enrolledCourses.value = json['data']['results'];
      } else {
        Get.snackbar('Error', json['message'] ?? 'Failed to fetch courses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
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
