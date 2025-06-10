import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class CertificateController extends GetxController {
  final LoginController _loginController = Get.find<LoginController>();
  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';

  var isLoading = false.obs;
  var downloadSuccess = false.obs;
  var errorMessage = ''.obs;

  // Check if the course is completed (progress is 100%)
  bool canDownloadCertificate(double progress) {
    return progress >= 1.0; // 1.0 represents 100%
  }

  // Download certificate from the API
  Future<void> downloadCertificate(String courseId, double progress) async {
    // Validate progress is 100%
    if (!canDownloadCertificate(progress)) {
      errorMessage.value = 'Course must be completed to download certificate';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      downloadSuccess.value = false;

      final token = _loginController.token.value;
      if (token.isEmpty) {
        errorMessage.value = 'No token available. Please login again.';
        return;
      }

      // Convert progress to 100 for the API requirement
      final int progressValue = 100; // API requires progress to be exactly 100

      final response = await http.post(
        Uri.parse('$baseUrl/certificate/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'courseId': courseId, 'score': progressValue}),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == 'SUCCESS') {
        downloadSuccess.value = true;
        // Handle the certificate data here
        // This could involve saving the certificate or opening it
        Get.snackbar('Success', 'Certificate downloaded successfully');
      } else {
        errorMessage.value =
            jsonResponse['message'] ?? 'Failed to download certificate';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
