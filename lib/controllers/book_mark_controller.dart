import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show min;
import 'login_controller.dart';

class BookmarkController extends GetxController {
  var isLoading = true.obs;
  var courses = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;

  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';
  final LoginController _loginController = Get.find<LoginController>();

  @override
  void onInit() {
    super.onInit();
    ever(_loginController.isFreshLogin, (isFresh) {
      if (isFresh == true) {
        fetchWishlist();
        _loginController.isFreshLogin.value = false; 
      }
    });
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = Uri.parse('$baseUrl/course/wishlist');
      print('Fetching wishlist from: ${url.toString()}');

      if (_loginController.token.value.isEmpty) {
        print('No token available for fetchWishlist');
        errorMessage.value = 'Please login to view your wishlist.';
        isLoading.value = false;
        return;
      }

      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      print(
          'Using auth token: ${_loginController.token.value.isNotEmpty ? _loginController.token.value.substring(0, min(_loginController.token.value.length, 10)) : "empty"}...');
      final response = await http.get(url, headers: authHeaders);
      print('Wishlist API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        final responseBodyPreview = response.body.length > 300
            ? response.body.substring(0, 300)
            : response.body;
        print('Wishlist API response body: $responseBodyPreview...');

        if (jsonRes['status'] == 'SUCCESS') {
          final raw = (jsonRes['data']?['resutls'] as List?) ?? [];
          print('Found ${raw.length} courses in API response');

          courses.assignAll(
            raw
                .map<Map<String, dynamic>>((course) {
                  if (course is! Map) {
                    print('Invalid course data (not a Map): $course');
                    return <String, dynamic>{};
                  }
                  try {
                    final mappedCourse = {
                      'id': course['_id']?.toString() ?? '',
                      'title': course['title']?.toString() ?? 'Untitled',
                      'price': course['price']?['amount']?.toString() ?? '0',
                      'image': course['thumbnail']?.toString() ?? '',
                      'rating': course['ratingsAverage']?.toString() ?? '0.0',
                      'instructorName': course['instructor']?.toString() ??
                          'Unknown Instructor',
                      'isBookMarked': true,
                    };
                    print('Mapped course: $mappedCourse');
                    return mappedCourse;
                  } catch (e) {
                    print('Error mapping course: $course, Error: $e');
                    return <String, dynamic>{};
                  }
                })
                .where((course) => course.isNotEmpty)
                .toList(),
          );

          print('Courses after mapping: ${courses.length}');
           
        } 
      } else if (response.statusCode == 401) {
        print('Unauthorized response: ${response.body}');
        await _redirectToLogin('Session expired. Please login again.');
      } else if (response.statusCode == 422) {
        print('Validation error response: ${response.body}');
        Get.snackbar('Error',
            'Invalid request: ${jsonDecode(response.body)['message'] ?? 'Validation error'}');
      } else if (response.statusCode == 404) {
        print('Not found response: ${response.body}');
        Get.snackbar('Error',
            'Wishlist route not found: ${jsonDecode(response.body)['message'] ?? 'Not found'}');
      } else {
        print('Error response: ${response.body}');
        Get.snackbar(
            'Error', 'Error fetching wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchWishlist: $e');
      Get.snackbar('Error', 'Failed to load wishlist: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToWishlist(String courseId) async {
    try {
      if (_loginController.token.value.isEmpty) {
        print('No token available for addToWishlist');
        await _redirectToLogin('Please login to add to wishlist.');
        return;
      }

      // Use the correct URL as specified
      final url = Uri.parse('$baseUrl/course/wishlist');
      print('Adding course to wishlist: ${url.toString()}');

      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      print(
          'Using auth token: ${_loginController.token.value.isNotEmpty ? _loginController.token.value.substring(0, min(_loginController.token.value.length, 10)) : "empty"}...');

      final response = await http.put(
        url,
        headers: authHeaders,
        body: jsonEncode({'courseId': courseId}),
      );
      print('Add wishlist API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        final responseBodyPreview = response.body.length > 300
            ? response.body.substring(0, 300)
            : response.body;
        print('Add wishlist API response body: $responseBodyPreview...');

        if (jsonRes['status'] == 'SUCCESS') {
          await fetchWishlist();
          Get.snackbar(
              'Success', jsonRes['message'] ?? 'Course added to wishlist');
        } else {
          Get.snackbar('Error', jsonRes['message'] ?? 'Failed to add course');
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized response: ${response.body}');
        await _redirectToLogin('Session expired. Please login again.');
      } else if (response.statusCode == 422) {
        print('Validation error response: ${response.body}');
        Get.snackbar('Error',
            'Invalid course ID: ${jsonDecode(response.body)['message'] ?? 'Validation error'}');
      } else if (response.statusCode == 404) {
        print('Not found response: ${response.body}');
        Get.snackbar('Error',
            'Wishlist route not found: ${jsonDecode(response.body)['message'] ?? 'Not found'}');
      } else {
        print('Error response: ${response.body}');
        Get.snackbar('Error', 'Error adding course: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in addToWishlist: $e');
      Get.snackbar('Error', 'Failed to add course: $e');
    }
  }

  Future<void> removeFromWishlist(String courseId) async {
    try {
      if (_loginController.token.value.isEmpty) {
        print('No token available for removeFromWishlist');
        await _redirectToLogin('Please login to remove from wishlist.');
        return;
      }

      // Use the correct URL as specified
      final url = Uri.parse('$baseUrl/course/wishlist');
      print('Removing course from wishlist: ${url.toString()}');

      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      print(
          'Using auth token: ${_loginController.token.value.isNotEmpty ? _loginController.token.value.substring(0, min(_loginController.token.value.length, 10)) : "empty"}...');

      // Assuming the backend expects the courseId in the body as JSON
      final response = await http.put(
        url,
        headers: authHeaders,
        body: jsonEncode({'courseId': courseId}),
      );
      print('Remove bookmark API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);
        if (jsonRes['status'] == 'SUCCESS') {
          courses.removeWhere((course) => course['id'] == courseId);
          Get.snackbar('Success', 'Course removed from wishlist');
        } else {
          Get.snackbar(
              'Error', jsonRes['message'] ?? 'Failed to remove course');
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized response: ${response.body}');
        await _redirectToLogin('Session expired. Please login again.');
      } else if (response.statusCode == 422) {
        print('Validation error response: ${response.body}');
        Get.snackbar('Error',
            'Invalid course ID: ${jsonDecode(response.body)['message'] ?? 'Validation error'}');
      } else if (response.statusCode == 404) {
        print('Not found response: ${response.body}');
        Get.snackbar('Error',
            'Wishlist route not found: ${jsonDecode(response.body)['message'] ?? 'Not found'}');
      } else {
        print('Error response: ${response.body}');
        Get.snackbar('Error', 'Error removing course: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in removeFromWishlist: $e');
      Get.snackbar('Error', 'Failed to remove course: $e');
    }
  }

  Future<void> toggleBookmark(
      String courseId, bool isCurrentlyBookmarked) async {
    try {
      if (_loginController.token.value.isEmpty) {
        print('No token available for toggleBookmark');
        await _redirectToLogin('Please login to modify wishlist.');
        return;
      }

      if (isCurrentlyBookmarked) {
        await removeFromWishlist(courseId);
      } else {
        await addToWishlist(courseId);
      }
    } catch (e) {
      print('Exception in toggleBookmark: $e');
      Get.snackbar('Error', 'Failed to update wishlist: $e');
    }
  }

  List<Map<String, dynamic>> filterCoursesByCategory(String? category) {
    try {
      final validCourses = courses.where((course) {
        final isValid = course is Map<String, dynamic>;
        if (!isValid) {
          print('Invalid course in filterCoursesByCategory: $course');
        }
        return isValid;
      }).toList();

      print('Filtering courses: ${validCourses.length}, category: $category');
      if (category == null || category == 'All') {
        return validCourses;
      }
      return validCourses.where((course) {
        final courseCategory = course['category']?.toString() ?? 'Unknown';
        final matches = courseCategory == category;
        if (!matches) {
          print(
              'Course ${course['id']} category $courseCategory does not match $category');
        }
        return matches;
      }).toList();
    } catch (e) {
      print('Exception in filterCoursesByCategory: $e');
      return [];
    }
  }

  Future<void> _redirectToLogin(String message) async {
    errorMessage.value = message;
    Get.snackbar(
      'Session Expired',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: Duration(seconds: 3),
    );
   
  }
}
