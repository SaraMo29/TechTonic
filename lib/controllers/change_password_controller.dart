import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading.value = true;
    final loginController = Get.find<LoginController>();
    final token = loginController.token.value;
    final url = Uri.parse('https://nafsi.onrender.com/api/v1/users/changeMyPassword');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
          'passwordConfirm': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'SUCCESS') {
        Get.snackbar('Success', 'Password changed successfully!');
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}