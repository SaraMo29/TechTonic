import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'transaction_screen.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({Key? key}) : super(key: key);
  final dynamic txData = Get.arguments;
  final df = DateFormat('MMM dd, yyyy | HH:mm:ss');
  
  // Check if the data is a TransactionModel or a Map
  bool get isTransactionModel => txData is TransactionModel;

  String get _paymentMethod {
    if (isTransactionModel) {
      final tx = txData as TransactionModel;
      if (tx.purchasePhone.startsWith('010')) return 'Vodafone Cash';
      if (tx.purchasePhone.startsWith('011')) return 'Etisalat Cash';
      return 'Other';
    } else {
      final data = txData as Map<String, dynamic>;
      return data['Payment Method'] ?? 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<TransactionController>().fetchTransactions();
        Get.off(() => TransactionScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("E-Receipt", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Get.find<TransactionController>().fetchTransactions();
              Get.off(() => TransactionScreen());
            },
          ),
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset('assets/images/e-receipt.jpg', height:100, fit:BoxFit.contain),
            const SizedBox(height:10),
            Center(child: Text(
              isTransactionModel 
                ? (txData as TransactionModel).transactionId 
                : ((txData as Map<String, dynamic>)['Transaction ID'] ?? 'N/A'),
              style: const TextStyle(fontWeight: FontWeight.w600)
            )),
            const SizedBox(height:20),

            _Section([
              _Info("Course", isTransactionModel 
                ? (txData as TransactionModel).courseTitle 
                : ((txData as Map<String, dynamic>)['Course'] ?? 'N/A')),
              _Info("Category", isTransactionModel 
                ? (txData as TransactionModel).courseCategory 
                : ((txData as Map<String, dynamic>)['Category'] ?? 'N/A')),
            ]),
            const SizedBox(height:16),

            _Section([
              _Info("Name", isTransactionModel 
                ? (txData as TransactionModel).userName 
                : ((txData as Map<String, dynamic>)['Name'] ?? 'N/A')),
              _Info("Email", isTransactionModel 
                ? (txData as TransactionModel).userEmail 
                : ((txData as Map<String, dynamic>)['Email'] ?? 'N/A')),
            ]),
            const SizedBox(height:16),

            _Section([
              _Info("Price", isTransactionModel 
                ? "${(txData as TransactionModel).coursePriceCurrency} ${(txData as TransactionModel).coursePriceAmount}" 
                : ((txData as Map<String, dynamic>)['Price'] ?? 'N/A')),
              _Info("Payment Method", _paymentMethod),
              _Info("Date", isTransactionModel 
                ? df.format((txData as TransactionModel).createdAt) 
                : ((txData as Map<String, dynamic>)['Date'] is DateTime 
                    ? df.format((txData as Map<String, dynamic>)['Date']) 
                    : ((txData as Map<String, dynamic>)['Date']?.toString() ?? 'N/A'))),
              _Info("Transaction ID", isTransactionModel 
                ? (txData as TransactionModel).transactionId 
                : ((txData as Map<String, dynamic>)['Transaction ID'] ?? 'N/A')),
              _Info("Status", isTransactionModel 
                ? (txData as TransactionModel).status 
                : ((txData as Map<String, dynamic>)['Status'] ?? 'Completed'), badge: true),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final List<Widget> children;
  const _Section(this.children);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }
}

class _Info extends StatelessWidget {
  final String label, value;
  final bool badge;
  const _Info(this.label, this.value, {this.badge = false});

  @override
  Widget build(BuildContext context) {
    final text = Text(
      value,
      style: badge
          ? const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
          : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          if (badge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal:10, vertical:5),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: text
            )
          else text,
        ],
      ),
    );
  }
}
