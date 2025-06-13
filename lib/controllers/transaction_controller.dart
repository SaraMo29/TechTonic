import 'dart:convert';
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
      final res = await http.get(
        Uri.parse('$_baseUrl/transaction/user'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['status'] == 'SUCCESS') {
        transactions.value = (body['data'] as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar('Error', body['message'] ?? 'Failed to load');
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
