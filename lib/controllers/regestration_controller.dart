import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:graduation_project/controllers/login_controller.dart';

class RegistrationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController linkedinUrlController = TextEditingController();

  RxString selectedGender = ''.obs;
  RxBool isLoading = false.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail(String selectedRole) async {
  isLoading.value = true;

  try {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://nafsi.onrender.com/api/v1/auth/register');

    Map<String, dynamic> body = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'role': selectedRole,
    };

    http.Response response = await http.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );

    final json = jsonDecode(response.body);

    // 👇 طباعة الداتا الراجعة من السيرفر
    print("Response JSON: $json");

    if (response.statusCode == 200 && json['status'] == 'SUCCESS') {
      final data = json['data'];
      print("Data inside success: $data");

      

      final token = data['token'];
      final userId = data['userId'];

      final loginController = Get.find<LoginController>();
      loginController.token.value = token;

      if (selectedRole == "instructor") {
        await updateInstructorData(userId, token);
      }

      await loginController.fetchUserProfile();
      await loginController.fetchCourses();

      Get.offAllNamed(selectedRole == "instructor" ? '/admin-home' : '/home');

      Get.snackbar(
        'Registration Successful',
        'Welcome, ${nameController.text}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      String errorMessage = json['message'] ?? 'An unknown error occurred';
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Registration Failed',
      e.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

  Future<void> updateInstructorData(String userId, String token) async {
    try {
      final url = 'https://nafsi.onrender.com/api/v1/users/$userId';

      Map<String, dynamic> instructorData = {
        "jobTitle": jobTitleController.text.trim(),
        "jobDescription": jobDescriptionController.text.trim(),
        "gender": selectedGender.value,
        "linkedinUrl": linkedinUrlController.text.trim(),
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(instructorData),
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 200 && res['status'] == 'SUCCESS') {
        print('Instructor data updated successfully');
      } else {
        print('Failed to update instructor: ${res['message']}');
      }
    } catch (e) {
      print('Error updating instructor data: $e');
    }
  }
}
