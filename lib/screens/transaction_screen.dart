import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../components/custom_bottomNavigationbar.dart';
import 'e_receipt_screen.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);
  final ctrl = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.transactions.isEmpty) {
          return const Center(child: Text("No transactions found."));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) {
            final tx = ctrl.transactions[i];
            return _TransactionTile(tx);
          },
        );
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final tx;
  const _TransactionTile(this.tx);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(tx.courseImage, width:50, height:50, fit:BoxFit.cover),
        ),
        title: Text(tx.courseTitle),
        subtitle: Text(tx.status, style: const TextStyle(color: Colors.blue)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            shape: const StadiumBorder(),
          ),
          onPressed: () => Get.to(() => ReceiptScreen(), arguments: tx),
          child: const Text("E-Receipt", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
