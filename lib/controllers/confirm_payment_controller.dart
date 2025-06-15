import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'login_controller.dart';

class ConfirmPaymentController extends GetxController {
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final receiptData = <String, dynamic>{}.obs;

  final _loginCtrl = Get.find<LoginController>();
  static const _baseUrl = 'https://nafsi.onrender.com/api/v1';

  Future<bool> processPayment(String courseId) async {
    if (_loginCtrl.token.value.isEmpty) {
      _handleError('Please login first.');
      return false;
    }

    print('Processing payment for course ID: $courseId');
    print('Phone number: ${phoneController.text.trim()}');
    
    isLoading.value = true;
    errorMessage.value = '';
    receiptData.clear();

    try {
      print('Sending payment request to API...');
      final res = await http.post(
        Uri.parse('$_baseUrl/transaction'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_loginCtrl.token.value}',
        },
        body: jsonEncode({
          'phoneNumber': phoneController.text.trim(),
          'courseId': courseId,
        }),
      );

      print('Payment API response status: ${res.statusCode}');
      print('Payment API response body: ${res.body}');
      
      final jsonRes = jsonDecode(res.body);
      if ((res.statusCode == 200 || res.statusCode == 201)
          && jsonRes['status'] == 'SUCCESS') {
        print('Payment successful!');
        final data = jsonRes['data']?['transaction'] ?? {};
        print('Transaction data: $data');

        final txPrice = data['transactionPrice'] ?? {};

        receiptData.value = {
          'Transaction ID': data['_id'] ?? 'N/A',
          'Course': 'N/A', // لا يوجد عنوان كورس في الريسبونس الحالي
          'Category': 'N/A',
          'Name': 'N/A', // لا يوجد معلومات مستخدم في الريسبونس الحالي
          'Email': 'N/A',
          'Price': "${txPrice['amount'] ?? 0} ${txPrice['currency'] ?? ''}",
          'Payment Method': _paymentMethod(phoneController.text.trim()),
          'Date': DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          'Status': data['status'] ?? 'Completed',
        };
        return true;
      } else if ((jsonRes['message']?.toString().toLowerCase()
          .contains('already enrolled') ?? false)) {
        print('User is already enrolled in this course');
        receiptData.value = {
          'Status': 'Already Enrolled',
        };
        return true;
      } else {
        print('Payment failed: ${jsonRes['message']}');
        _handleError(jsonRes['message'] ?? 'Payment failed');
        return false;
      }
    } catch (e) {
      print('Exception during payment process: $e');
      print('Stack trace: ${StackTrace.current}');
      _handleError('Error: $e');
      return false;
    } finally {
      print('Payment process completed, loading state set to false');
      isLoading.value = false;
    }
  }

  String _paymentMethod(String phone) {
    if (phone.startsWith('010')) return 'Vodafone Cash';
    if (phone.startsWith('011')) return 'Etisalat Cash';
    return 'Other';
  }

  void _handleError(String msg) {
    errorMessage.value = msg;
    Get.snackbar('Error', msg,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
    );
  }
}
