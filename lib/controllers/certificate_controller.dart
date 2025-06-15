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

  bool canDownloadCertificate(double progress) {
    return progress >= 1.0;
  }

  Future<void> downloadCertificate(String courseId, double progress) async {
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
        isLoading.value = false;
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/certificate/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'courseId': courseId, 'score': 100}),
      );

      final jsonResponse = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          jsonResponse['status'] == 'SUCCESS') {
        downloadSuccess.value = true;
        Get.snackbar('Success', 'Certificate downloaded successfully');
      } else {
        errorMessage.value =
            jsonResponse['message'] ?? 'Failed to download certificate';
        Get.snackbar('Error', errorMessage.value);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
