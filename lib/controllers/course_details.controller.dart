import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class CourseDetailsController extends GetxController {
  var isLoading = true.obs;
  var courseDetails = <String, dynamic>{}.obs;
  var aboutContent = <String, dynamic>{}.obs;
  var lessons = <Map<String, dynamic>>[].obs;
  var modules = <Map<String, dynamic>>[].obs;
  var reviews = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;

  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';
  final LoginController _loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCourseDetails(String courseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final url = Uri.parse('$baseUrl/course/$courseId');

      if (_loginController.token.value.isEmpty) {
        await _redirectToLogin('No token available. Please login again.');
        return;
      }

      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      final response = await http.get(url, headers: authHeaders);

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        if (jsonRes['status'] == 'SUCCESS') {
          final data = jsonRes['data']['results'];

          // Course Details
          courseDetails.value = {
            'title': data['title'] ?? 'No Title',
            'price': data['price']?['amount']?.toString() ?? '0',
            'discountPrice': data['discountPrice']?.toString(),
            'image': data['thumbnail'] ?? '',
            'rating': data['ratingsAverage']?.toString() ?? '0.0',
            'instructorName':
                data['instructor']?['name'] ?? 'Unknown Instructor',
            'instructorImage': data['instructor']?['profileImage'] ?? '',
            'instructorTitle': data['instructor']?['roles'] ?? 'Instructor',
            'trailerUrl': data['videoTrailer'] ?? '',
          };

          // About Content
          aboutContent.value = {
            'description':
                data['subTitle']?.toString().trim() ?? 'No description',
            'requirements': _toList(data['requirements']),
            'targetAudience': _toList(data['targetAudience']),
            'whatWillBeTaught': _toList(data['whatWillBeTaught']),
            'courseDescription':
                data['courseDescription']?.toString().trim() ?? '',
          };

          // Lessons (sections)
          lessons.assignAll(_buildLessons(data['sections']));

          // Modules (children)
          modules.assignAll(_buildModules(data['sections']));

          // Fetch reviews via separate endpoint
          await fetchReviews(courseId);

          Get.snackbar('Success', 'Course details loaded successfully');
        } else {
          Get.snackbar('Error', jsonRes['message'] ?? 'Failed to load');
        }
      } else {
        final err = jsonDecode(response.body);
        Get.snackbar('Error', err['message'] ?? 'Failed to load');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load course details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReviews(String courseId) async {
    try {
      final url = Uri.parse('$baseUrl/review/course/$courseId');
      print('Fetching reviews from: ${url.toString()}'); // Debug URL

      if (_loginController.token.value.isEmpty) {
        await _redirectToLogin('No token available. Please login again.');
        return;
      }

      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      print(
          'Using auth token: ${_loginController.token.value.substring(0, min(_loginController.token.value.length, 10))}...'); // Debug token (partial)
      final response = await http.get(url, headers: authHeaders);
      print(
          'Review API response status: ${response.statusCode}'); // Debug response code

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        print(
            'Review API response body: ${response.body.substring(0, min(response.body.length, 300))}...'); // Debug response (partial)

        if (jsonRes['status'] == 'SUCCESS') {
          // The data is now inside data['result']
          final raw = (jsonRes['data']?['result'] as List?) ?? [];
          print('Found ${raw.length} reviews'); // Debug review count

          reviews.assignAll(
            raw
                .map<Map<String, dynamic>>((r) => {
                      'userName': r['user']?['name'] ?? 'Anonymous',
                      'userImage': r['user']?['profileImage'] ?? '',
                      'content': r['comment'] ?? '',
                      'rating': r['rate']?.toString() ?? '0',
                      'likes': r['likes']?.toString() ?? '0',
                      'createdAt': r['createdAt'] ?? '',
                    })
                .toList(),
          );
          if (reviews.isEmpty) {
            Get.snackbar('Info', 'No reviews available for this course');
          }
        } else {
          Get.snackbar(
              'Error', jsonRes['message'] ?? 'Failed to fetch reviews');
        }
      } else if (response.statusCode == 404) {
        print('404 Error: ${response.body}'); // Debug 404 response
        Get.snackbar(
            'Error', 'Reviews endpoint not found (404). Check the URL.');
      } else {
        print('Error response: ${response.body}'); // Debug error response
        Get.snackbar('Error', 'Error fetching reviews: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception fetching reviews: $e');
    }
  }

  List<Map<String, dynamic>> _buildLessons(List? sections) {
    if (sections == null) return [];
    return sections.map<Map<String, dynamic>>((section) {
      final dur = section['sectionDuration'] ?? {};
      final totalSec = (dur['hours'] ?? 0) * 3600 +
          (dur['minutes'] ?? 0) * 60 +
          (dur['seconds'] ?? 0);
      final mins = totalSec ~/ 60;
      final secs = totalSec % 60;
      return {
        'id': section['_id'] ?? '',
        'title': section['title'] ?? 'Untitled Section',
        'duration': '$mins:${secs.toString().padLeft(2, '0')}',
        'isLocked': false,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _buildModules(List? sections) {
    if (sections == null) return [];
    final list = <Map<String, dynamic>>[];
    for (var section in sections) {
      for (var module in section['modules'] ?? []) {
        list.add({
          'id': module['_id'] ?? '',
          'lessonId': section['_id'] ?? '',
          'title': module['name'] ?? 'Untitled Module',
          'isFree': module['isFree'] ?? false,
        });
      }
    }
    return list;
  }

  List<String> _toList(dynamic field) {
    if (field == null) return [];
    return field
        .toString()
        .split('\n')
        .map((line) => line.trim().replaceFirst(RegExp(r'^-\s*'), ''))
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<void> _redirectToLogin(String message) async {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: Duration(seconds: 3),
    );
    await Future.delayed(Duration(seconds: 1));
    Get.offAllNamed('/login');
  }
}
