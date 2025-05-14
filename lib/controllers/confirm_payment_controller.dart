import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class ConfirmPaymentController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var receiptData = <String, dynamic>{}.obs;

  final LoginController _loginController = Get.find<LoginController>();
  static const String baseUrl = 'https://nafsi.onrender.com/api/v1';

  Future<bool> processPayment(String courseId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if token is available
      if (_loginController.token.value.isEmpty) {
        errorMessage.value = 'No token available. Please login again.';
        _showErrorSnackbar(errorMessage.value);
        Get.offAllNamed('/login');
        return false;
      }

      // Prepare API request
      final url = Uri.parse('$baseUrl/transaction');
      final authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_loginController.token.value}',
      };

      // Make the enrollment API call
      final response = await http.post(
        url,
        headers: authHeaders,
        body: jsonEncode({
          'phoneNumber': phoneController.text.trim(),
          'courseId': courseId,
        }),
      );

      // Process response
      final jsonRes = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonRes['status'] == 'SUCCESS') {
          // Store receipt data
          receiptData.value = {
            'Transaction ID': jsonRes['data']?['_id'] ?? 'N/A',
            'Course': jsonRes['data']?['course']?['title'] ?? 'N/A',
            'Price': jsonRes['data']?['amount'] != null 
                ? "EGP ${jsonRes['data']['amount']}" 
                : 'N/A',
            'Payment Method': _getPaymentMethodFromPhone(phoneController.text.trim()),
            'Phone Number':
                jsonRes['data']?['phoneNumber'] ?? phoneController.text.trim(),
            'Date': jsonRes['data']?['createdAt'] != null
                ? DateTime.parse(jsonRes['data']['createdAt'])
                : DateTime.now(),
            'Status': jsonRes['data']?['status'] ?? 'Completed',
          };
          return true;
        } else if (jsonRes['message']
                ?.toString()
                .toLowerCase()
                .contains('already enrolled') ??
            false) {
          // Handle already enrolled case
          receiptData.value = {
            'Transaction ID': 'N/A',
            'Course': 'Current Course',
            'Price': 'N/A',
            'Payment Method': _getPaymentMethodFromPhone(phoneController.text.trim()),
            'Phone Number': phoneController.text.trim(),
            'Date': DateTime.now(),
            'Status': 'Already Enrolled',
          };
          return true;
        } else {
          errorMessage.value = jsonRes['message'] ?? 'Payment failed';
          _showErrorSnackbar(errorMessage.value);
          return false;
        }
      } else {
        errorMessage.value = jsonRes['message'] ??
            'Payment failed with status ${response.statusCode}';
        _showErrorSnackbar(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      _showErrorSnackbar(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> getReceiptData() {
    return receiptData.value;
  }
  
  String _getPaymentMethodFromPhone(String phone) {
    if (phone.startsWith('010')) return 'Vodafone Cash';
    if (phone.startsWith('011')) return 'Etisalat Cash';
    return 'Other';
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      // ignore: deprecated_member_use
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: Duration(seconds: 3),
    );
  }
}
