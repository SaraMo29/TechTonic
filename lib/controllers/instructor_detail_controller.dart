import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class InstructorDetailController extends GetxController {
  var isLoading = false.obs;
  var instructorData = {}.obs;

  Future<void> fetchInstructorProfile(String instructorId) async {
    isLoading.value = true;
    print('Fetching instructor profile for ID: $instructorId'); // Debug print
    if (instructorId == null || instructorId.isEmpty || instructorId.length != 24) {
      Get.snackbar('Error', 'Instructor ID is missing or invalid.');
      isLoading.value = false;
      return;
    }
    final loginController = Get.find<LoginController>();
    final token = loginController.token.value;
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      return;
    }
    final url = Uri.parse('https://nafsi.onrender.com/api/v1/users/instructor-profile/?instructorId=$instructorId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        instructorData.value = data['data'];
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to fetch instructor');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}