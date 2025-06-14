import 'dart:convert';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import 'login_controller.dart';

class TransactionController extends GetxController {
  static const _baseUrl = 'https://nafsi.onrender.com/api/v1';
  final _loginCtrl = Get.find<LoginController>();

  final isLoading = false.obs;
  final transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // أول تحميل
    fetchTransactions();
    // إعادة التحميل كلما تغيّر التوكن (login/logout)
    ever(_loginCtrl.token, (_) {
      transactions.clear();
      fetchTransactions();
    });
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final token = _loginCtrl.token.value;
      if (token.isEmpty) {
        print('Token is empty, skipping transaction fetch');
        return;
      }
      
      print('Fetching transactions with token: ${token.substring(0, math.min(10, token.length))}...');
      final res = await http.get(
        Uri.parse('$_baseUrl/transaction/user'),
        headers: {'Authorization': 'Bearer $token'},
      );
      
      print('Transaction API response status: ${res.statusCode}');
      print('Transaction API response body: ${res.body.substring(0, math.min(200, res.body.length))}...');
      
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['status'] == 'SUCCESS') {
        final dataList = body['data'] as List;
        print('Found ${dataList.length} transactions');
        
        transactions.value = dataList
            .map((e) => TransactionModel.fromJson(e))
            .toList();
      } else {
        print('Error fetching transactions: ${body['message']}');
        Get.snackbar('Error', body['message'] ?? 'Failed to load transactions');
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
