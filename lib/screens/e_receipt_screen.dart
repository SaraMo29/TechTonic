import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'transaction_screen.dart';

class ReceiptScreen extends StatelessWidget {
  ReceiptScreen({Key? key}) : super(key: key);
  final tx = Get.arguments as TransactionModel;
  final df = DateFormat('MMM dd, yyyy | HH:mm:ss');

  String get _paymentMethod {
    if (tx.purchasePhone.startsWith('010')) return 'Vodafone Cash';
    if (tx.purchasePhone.startsWith('011')) return 'Etisalat Cash';
    return 'Other';
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
            Center(child: Text(tx.transactionId, style: const TextStyle(fontWeight: FontWeight.w600))),
            const SizedBox(height:20),

            _Section([
              _Info("Course", tx.courseTitle),
              _Info("Category", tx.courseCategory),
            ]),
            const SizedBox(height:16),

            _Section([
              _Info("Name", tx.userName),
              _Info("Email", tx.userEmail),
            ]),
            const SizedBox(height:16),

            _Section([
              _Info("Price", "${tx.coursePriceCurrency} ${tx.coursePriceAmount}"),
              _Info("Payment Method", _paymentMethod),
              _Info("Date", df.format(tx.createdAt)),
              _Info("Transaction ID", tx.transactionId),
              _Info("Status", tx.status, badge: true),
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
