
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;
  var token = ''.obs; 
  var courses = <Map<String, dynamic>>[].obs; 

  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';
  final Map<String, String> headers = {'Content-Type': 'application/json'};


  Future<void> loginWithEmail() async {
    try {
      isLoading.value = true;
      var url = Uri.parse('$baseUrl/auth/login');
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'SUCCESS') {
          token.value = json['data']['token'];
          await fetchCourses(); 
          Get.offNamed('/home');
          _showSuccessSnackbar('Login Successful', 'Welcome back!');
        }
      } else {
        var error = jsonDecode(response.body);
        String errorMessage = error['message'] ?? 'An unknown error occurred';
        _showErrorSnackbar('Login Failed', errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;
      var url = Uri.parse('$baseUrl/course/'); 
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'SUCCESS') {
          courses.value = List<Map<String, dynamic>>.from(json['data']['results']);
        }
      } else {
        var error = jsonDecode(response.body);
        _showErrorSnackbar('Error', error['message'] ?? 'Failed to fetch courses');
      }
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to fetch courses: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> sendOtp() async {
    try {
      isLoading.value = true;
      final email = emailController.text.trim();
      if (!GetUtils.isEmail(email)) {
        _showErrorSnackbar("Error", "Please enter a valid email");
        return;
      }

      var url = Uri.parse('$baseUrl/auth/forget-password');
      Map body = {'email': email};

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'SUCCESS') {
          _showSuccessSnackbar("Success", json['message'] ?? "OTP sent to your email");
          Get.toNamed('/otp-verification', arguments: {'email': email});
        }
      } else {
        var error = jsonDecode(response.body);
        String errorMessage = error['message'] ?? 'Failed to send OTP';
        _showErrorSnackbar("Error", errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar("Error", "Failed to send OTP: $e");
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> verifyOtp(String email, String otp) async {
    try {
      isLoading.value = true;
      var url = Uri.parse('$baseUrl/auth/confirm-reset');
      Map body = {
        'email': email,
        'resetCode': otp,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'SUCCESS') {
          _showSuccessSnackbar("Success", json['message'] ?? "OTP verified");
          Get.toNamed('/create-new-password', arguments: {'email': email, 'otp': otp});
        }
      } else {
        var error = jsonDecode(response.body);
        String errorMessage = error['message'] ?? 'Invalid OTP';
        _showErrorSnackbar("Error", errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar("Error", "Failed to verify OTP: $e");
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> resetPassword(String email, String otp, String password) async {
    try {
      isLoading.value = true;
      var url = Uri.parse('$baseUrl/auth/reset-password');
      Map body = {
        'email': email,
        'resetCode': otp,
        'password': password,
        'passwordConfirm': password,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'SUCCESS') {
          _showSuccessSnackbar("Success", json['message'] ?? "Password reset successfully");
          Get.offAllNamed('/login');
        }
      } else {
        var error = jsonDecode(response.body);
        String errorMessage = error['message'] ?? 'Failed to reset password';
        _showErrorSnackbar("Error", errorMessage);
      }
    } catch (e) {
      _showErrorSnackbar("Error", "Failed to reset password: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    token.value = '';
    courses.clear();
    Get.offAllNamed('/login');
    _showSuccessSnackbar("Logged Out", "You have been logged out successfully");
  }


  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }


  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}